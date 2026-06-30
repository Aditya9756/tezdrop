import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/address_model.dart';
import '../../core/services/location_service.dart';
import '../../providers/app_state_provider.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});
  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _nameCtrl     = TextEditingController();
  final _phoneCtrl    = TextEditingController();
  final _flatCtrl     = TextEditingController();
  final _areaCtrl     = TextEditingController();
  final _landmarkCtrl = TextEditingController();
  String _addrType   = 'home';
  bool   _gpsLoading = false;
  double? _lat, _lng;

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose();
    _flatCtrl.dispose(); _areaCtrl.dispose(); _landmarkCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating));

  Future<void> _fetchGps() async {
    setState(() => _gpsLoading = true);
    final pos = await LocationService.getCurrentPosition();
    if (pos != null) {
      final addr = await LocationService.getAddressFromCoords(pos.latitude, pos.longitude);
      setState(() { _lat = pos.latitude; _lng = pos.longitude; _areaCtrl.text = addr; _gpsLoading = false; });
      _snack('Location fetched! 📍');
    } else {
      setState(() => _gpsLoading = false);
      _snack('GPS denied. Enter area manually.');
    }
  }

  void _save() {
    final area = _areaCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    if (area.isEmpty) { _snack('Please enter area or use GPS'); return; }
    if (name.isEmpty) { _snack('Please enter your name'); return; }
    if (phone.isEmpty) { _snack('Please enter phone number'); return; }
    if (phone.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
      _snack('Please enter a valid 10-digit Indian mobile number');
      return;
    }

    context.read<AppStateProvider>().addAddress(AddressModel(
      type: _addrType, name: name, phone: phone,
      flat: _flatCtrl.text.trim(), area: area, landmark: _landmarkCtrl.text.trim(),
      lat: _lat, lng: _lng,
    ));
    _snack('Address saved! 🏠');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Address')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GestureDetector(
          onTap: _gpsLoading ? null : _fetchGps,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBBF7D0))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _gpsLoading
                ? const SizedBox(width:18, height:18, child: CircularProgressIndicator(strokeWidth:2, color: AppColors.green))
                : const Icon(Icons.gps_fixed, color: AppColors.green, size: 18),
              const SizedBox(width: 8),
              Text(_gpsLoading ? 'Fetching...' : _lat != null ? 'Location Fetched ✓' : 'Use Current Location',
                style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.bold, fontSize: 13)),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        TextField(controller: _nameCtrl, decoration: const InputDecoration(hintText: 'Full Name')),
        const SizedBox(height: 12),
        TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: 'Phone Number')),
        const SizedBox(height: 12),
        TextField(controller: _flatCtrl, decoration: const InputDecoration(hintText: 'Flat, House No, Building')),
        const SizedBox(height: 12),
        TextField(controller: _areaCtrl, maxLines: 2, decoration: const InputDecoration(hintText: 'Area, Sector, Locality')),
        const SizedBox(height: 12),
        TextField(controller: _landmarkCtrl, decoration: const InputDecoration(hintText: 'Landmark (optional)')),
        const SizedBox(height: 16),
        Row(children: [
          _TypeBtn('🏠 Home', 'home', _addrType, (v) => setState(() => _addrType = v)),
          const SizedBox(width: 8),
          _TypeBtn('💼 Work', 'work', _addrType, (v) => setState(() => _addrType = v)),
          const SizedBox(width: 8),
          _TypeBtn('📍 Other', 'other', _addrType, (v) => setState(() => _addrType = v)),
        ]),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _save, child: const Text('Save Address'))),
        const SizedBox(height: 24),
      ]),
    );
  }
}

class _TypeBtn extends StatelessWidget {
  final String label, val, current;
  final void Function(String) onTap;
  const _TypeBtn(this.label, this.val, this.current, this.onTap);
  @override
  Widget build(BuildContext context) {
    final active = current == val;
    return Expanded(child: GestureDetector(
      onTap: () => onTap(val),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFEE2E2) : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? AppColors.primary : AppColors.border, width: active ? 2 : 1)),
        child: Text(label, textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,
            color: active ? AppColors.primary : AppColors.textGrey)),
      ),
    ));
  }
}
