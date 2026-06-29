import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RoutingService {
  /// OSRM se road path fetch karo (free, no API key needed)
  static Future<List<LatLng>> getRoadPath({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) async {
    try {
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving'
        '/$fromLng,$fromLat;$toLng,$toLat'
        '?overview=full&geometries=geojson&steps=false',
      );
      final res = await http
          .get(url)
          .timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['code'] == 'Ok' && data['routes'] != null) {
          final coords = data['routes'][0]['geometry']['coordinates'] as List;
          return coords
              .map((c) => LatLng(
                    (c[1] as num).toDouble(),
                    (c[0] as num).toDouble(),
                  ))
              .toList();
        }
      }
    } catch (_) {}
    return _straightLinePath(fromLat, fromLng, toLat, toLng);
  }

  /// Straight line fallback — 20 interpolated points
  static List<LatLng> _straightLinePath(
    double lat1, double lng1, double lat2, double lng2, {int steps = 20}) {
    return List.generate(
      steps + 1,
      (i) => LatLng(
        lat1 + (lat2 - lat1) * i / steps,
        lng1 + (lng2 - lng1) * i / steps,
      ),
    );
  }

  /// Bearing angle calculate karo (bike rotation ke liye)
  static double getBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * math.pi / 180;
    final lat2 = to.latitude  * math.pi / 180;
    final dLng = (to.longitude - from.longitude) * math.pi / 180;
    final y = math.sin(dLng) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
              math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }
}
