import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_strings.dart';
import '../models/order_model.dart';

class FirebaseService {
  static const String _base = AppStrings.firebaseUrl;

  // ─── Orders ─────────────────────────────────────────────

  /// Place new order → returns Firebase push key
  static Future<String?> placeOrder(Map<String, dynamic> orderData) async {
    try {
      final res = await http
          .post(
            Uri.parse('$_base/orders.json'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(orderData),
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['name'] as String?; // Firebase push key
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Load all orders for a phone number
  static Future<List<OrderModel>> loadOrders(String phone) async {
    try {
      final res = await http
          .get(Uri.parse('$_base/orders.json'))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) return [];
      final data = jsonDecode(res.body);
      if (data == null || data is! Map) return [];

      final orders = <OrderModel>[];
      (data as Map).forEach((key, value) {
        if (value is Map) {
          final order = OrderModel.fromJson(
            Map<String, dynamic>.from(value),
            key: key,
          );
          if (order.phone == phone) orders.add(order);
        }
      });
      // Newest first
      orders.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return orders;
    } catch (_) {
      return [];
    }
  }

  /// Update order status by Firebase key
  static Future<bool> updateOrderStatus(
      String firebaseKey, String status) async {
    try {
      final res = await http
          .put(
            Uri.parse('$_base/orders/$firebaseKey/status.json'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(status),
          )
          .timeout(const Duration(seconds: 10));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ─── Fetch all app data (categories/products/restaurants/grocery) ───

  static Future<Map<String, dynamic>?> fetchAllData() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/.json'))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is Map) return Map<String, dynamic>.from(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ─── Ratings ────────────────────────────────────────────

  static Future<void> submitRating(Map<String, dynamic> ratingData) async {
    try {
      await http
          .post(
            Uri.parse('$_base/ratings.json'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(ratingData),
          )
          .timeout(const Duration(seconds: 8));
    } catch (_) {}
  }

  // ─── Rider Location ─────────────────────────────────────

  static Future<Map<String, dynamic>?> getRiderLocation(
      String orderId) async {
    try {
      final res = await http
          .get(Uri.parse(
              '$_base/rider_locations/$orderId.json?t=${DateTime.now().millisecondsSinceEpoch}'))
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200 && res.body != 'null') {
        final data = jsonDecode(res.body);
        if (data is Map) return Map<String, dynamic>.from(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Get order by orderId (polls all orders, finds matching)
  static Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final res = await http
          .get(Uri.parse('$_base/orders.json'))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body);
      if (data == null || data is! Map) return null;
      for (final entry in (data as Map).entries) {
        if (entry.value is Map) {
          final order = OrderModel.fromJson(
            Map<String, dynamic>.from(entry.value as Map),
            key: entry.key as String,
          );
          if (order.orderId == orderId) return order;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
