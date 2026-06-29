import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/location_service.dart';
import '../../core/services/routing_service.dart';
import '../../core/services/firebase_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId, riderName, riderPhone;
  const OrderTrackingScreen({super.key, required this.orderId, required this.riderName, required this.riderPhone});
  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final MapController _mapCtrl = MapController();
  LatLng _userPos  = const LatLng(28.6139, 77.2090);
  LatLng _riderPos = const LatLng(28.6220, 77.2180);
  List<LatLng> _route = [];
  int _secs = 900;
  Timer? _timer, _bikeTimer, _pollTimer;
  int _bikeIdx = 0;
  double _bearing = 180;
  String _riderName = '';
  String _gpsInfo = 'Connecting...';

  final List<_Step> _steps = [
    _Step('Placed', Icons.check, true, false),
    _Step('Preparing', Icons.local_fire_department, false, true),
    _Step('Packed', Icons.inventory_2, false, false),
    _Step('On Way', Icons.motorcycle, false, false),
    _Step('Delivered', Icons.home, false, false),
  ];

  @override
  void initState() {
    super.initState();
    _riderName = widget.riderName;
    _load();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _secs > 0) setState(() => _secs--);
    });
    for (int i = 0; i < 4; i++) {
      Future.delayed(Duration(seconds: [60,120,180,240][i]), () {
        if (!mounted) return;
        setState(() {
          _steps[i].done = true; _steps[i].active = false;
          if (i + 1 < _steps.length) _steps[i+1].active = true;
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); _bikeTimer?.cancel(); _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final pos = await LocationService.getCurrentPosition();
    if (pos != null && mounted) {
      setState(() {
        _userPos  = LatLng(pos.latitude, pos.longitude);
        _riderPos = LatLng(pos.latitude + 0.012, pos.longitude + 0.008);
      });
    }
    final path = await RoutingService.getRoadPath(
      fromLat: _riderPos.latitude, fromLng: _riderPos.longitude,
      toLat: _userPos.latitude, toLng: _userPos.longitude,
    );
    if (!mounted) return;
    setState(() { _route = path; _gpsInfo = 'Road path ready — ${path.length} points'; });
    if (path.length > 1) {
      final stepMs = (25000 / path.length).round().clamp(100, 2000);
      _bikeTimer = Timer.periodic(Duration(milliseconds: stepMs), (_) {
        if (!mounted || _bikeIdx >= _route.length - 1) { _bikeTimer?.cancel(); return; }
        setState(() {
          _bikeIdx++;
          _bearing = RoutingService.getBearing(_route[_bikeIdx-1], _route[_bikeIdx]);
          _riderPos = _route[_bikeIdx];
        });
      });
    }
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final d = await FirebaseService.getRiderLocation(widget.orderId);
      if (d == null || !mounted) return;
      final lat = (d['lat'] as num?)?.toDouble();
      final lng = (d['lng'] as num?)?.toDouble();
      if (lat != null && lng != null) {
        setState(() {
          _bearing = RoutingService.getBearing(_riderPos, LatLng(lat, lng));
          _riderPos = LatLng(lat, lng);
          _gpsInfo = 'Live: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
        });
      }
    });
  }

  String get _timerLabel {
    if (_secs <= 0) return 'Arrived!';
    return '${(_secs~/60).toString().padLeft(2,'0')}:${(_secs%60).toString().padLeft(2,'0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Stack(children: [
            FlutterMap(
              mapController: _mapCtrl,
              options: MapOptions(
                initialCenter: LatLng((_userPos.latitude+_riderPos.latitude)/2, (_userPos.longitude+_riderPos.longitude)/2),
                initialZoom: 14,
              ),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.tezdrop.app'),
                if (_route.length > 1)
                  PolylineLayer(polylines: [
                    Polyline(points: _route.sublist(_bikeIdx), color: AppColors.primary, strokeWidth: 4),
                  ]),
                MarkerLayer(markers: [
                  Marker(point: _userPos, width: 40, height: 40, child: const Icon(Icons.location_on, color: AppColors.primary, size: 36)),
                  Marker(point: _riderPos, width: 40, height: 40,
                    child: Transform.rotate(angle: _bearing * 3.14159/180, child: const Text('🛵', style: TextStyle(fontSize: 28)))),
                ]),
              ],
            ),
            Positioned(top: MediaQuery.of(context).padding.top + 8, left: 12,
              child: GestureDetector(onTap: () => Navigator.pop(context),
                child: Container(width:38, height:38,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back, size: 20)))),
            Positioned(top: MediaQuery.of(context).padding.top + 8, right: 12,
              child: Container(padding: const EdgeInsets.symmetric(horizontal:10, vertical:5),
                decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(999)),
                child: const Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)))),
          ]),
        ),
        Expanded(child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: ListView(padding: const EdgeInsets.all(20), children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Text('Arriving in ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(_timerLabel, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary)),
                ]),
                Text('Order #${widget.orderId}', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
              ]),
              Container(width:46, height:46,
                decoration: BoxDecoration(color: const Color(0xFFF0FDF4), shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFBBF7D0), width:2)),
                child: const Icon(Icons.motorcycle, color: AppColors.green, size:22)),
            ]),
            const SizedBox(height: 16),
            Row(children: _steps.asMap().entries.map((e) {
              final i = e.key; final s = e.value;
              return Expanded(child: Row(children: [
                Expanded(child: Column(children: [
                  Container(width:30, height:30,
                    decoration: BoxDecoration(
                      color: s.done ? AppColors.green : s.active ? AppColors.primary : AppColors.border,
                      shape: BoxShape.circle),
                    child: Icon(s.icon, color: (s.done||s.active) ? Colors.white : AppColors.textLight, size:13)),
                  const SizedBox(height:4),
                  Text(s.label, style: TextStyle(fontSize:8, fontWeight: FontWeight.bold,
                    color: s.done ? AppColors.green : s.active ? AppColors.primary : AppColors.textLight),
                    textAlign: TextAlign.center),
                ])),
                if (i < _steps.length-1)
                  Expanded(child: Container(height:2, margin: const EdgeInsets.only(bottom:18),
                    color: _steps[i].done ? AppColors.green : AppColors.border)),
              ]));
            }).toList()),
            const SizedBox(height: 16),
            Container(padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Icon(Icons.location_on, color: AppColors.blue, size:16),
                const SizedBox(width:8),
                Expanded(child: Text(_gpsInfo, style: const TextStyle(color: AppColors.blue, fontSize:11))),
              ])),
            const SizedBox(height: 14),
            Container(padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                const CircleAvatar(backgroundColor: AppColors.border, child: Text('🧑')),
                const SizedBox(width:12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_riderName.isEmpty ? 'Assigning...' : '$_riderName (Support)',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text('⭐ 4.8 Rating', style: TextStyle(fontSize:11, color: AppColors.textGrey)),
                ])),
                GestureDetector(
                  onTap: () async {
                    if (widget.riderPhone.isNotEmpty) {
                      final u = Uri.parse('tel:${widget.riderPhone}');
                      if (await canLaunchUrl(u)) launchUrl(u);
                    }
                  },
                  child: Container(width:40, height:40,
                    decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
                    child: const Icon(Icons.phone, color: AppColors.green, size:18))),
              ])),
          ]),
        )),
      ]),
    );
  }
}

class _Step {
  final String label; final IconData icon; bool done, active;
  _Step(this.label, this.icon, this.done, this.active);
}
