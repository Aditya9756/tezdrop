import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  /// Get device GPS position
  static Future<Position?> getCurrentPosition() async {
    try {
      bool enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return null;

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) return null;
      }
      if (perm == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (_) {
      return null;
    }
  }

  /// Reverse geocode lat/lng → address string via Nominatim
  static Future<String> getAddressFromCoords(
      double lat, double lng) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng',
      );
      final res = await http.get(
        url,
        headers: {'User-Agent': 'TezDropDeliveryApp/1.0'},
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final addr = data['address'] as Map?;
        if (addr != null) {
          final parts = <String>[];
          if (addr['road']   != null) parts.add(addr['road']);
          if (addr['suburb'] != null) parts.add(addr['suburb']);
          if (addr['city']   != null) parts.add(addr['city']);
          if (addr['state']  != null) parts.add(addr['state']);
          if (parts.isNotEmpty) return parts.take(3).join(', ');
        }
        return data['display_name'] ?? 'Current Location';
      }
      return 'Current Location';
    } catch (_) {
      return 'Current Location';
    }
  }

  /// Search address suggestions via Nominatim
  static Future<List<Map<String, dynamic>>> searchAddress(
      String query) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json'
        '&q=${Uri.encodeComponent(query)}&countrycodes=in&limit=5',
      );
      final res = await http.get(
        url,
        headers: {'User-Agent': 'TezDropDeliveryApp/1.0'},
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map<Map<String, dynamic>>((item) => {
          'name': item['display_name'] ?? '',
          'lat' : double.tryParse(item['lat'].toString()) ?? 0.0,
          'lng' : double.tryParse(item['lon'].toString()) ?? 0.0,
        }).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
