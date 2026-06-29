import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    context.read<AppStateProvider>().markNotificationsRead();
    final notifs = [
      {'icon': Icons.local_shipping_outlined, 'color': AppColors.primary, 'title': 'Order Confirmed!', 'body': 'Your order is being prepared.', 'time': 'Just now', 'unread': true},
      {'icon': Icons.monetization_on_outlined, 'color': AppColors.yellow, 'title': 'TezCoins Earned!', 'body': 'Coins added for your last order.', 'time': '1 hour ago', 'unread': false},
      {'icon': Icons.shopping_basket_outlined, 'color': AppColors.green, 'title': 'Fresh Groceries Available!', 'body': 'Order vegetables, dairy & more.', 'time': 'Today', 'unread': false},
      {'icon': Icons.local_offer_outlined, 'color': const Color(0xFF7C3AED), 'title': 'New Offer: TEZDROP50', 'body': '50% off on your next order!', 'time': 'Yesterday', 'unread': false},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'),
        actions: [TextButton(onPressed: () {}, child: const Text('Mark all read', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)))]),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifs.length,
        itemBuilder: (_, i) {
          final n = notifs[i]; final unread = n['unread'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border(left: BorderSide(color: unread ? AppColors.primary : Colors.transparent, width: 4)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(
                color: (n['color'] as Color).withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 18)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(n['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 3),
                Text(n['body'] as String, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(n['time'] as String, style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
              ])),
            ]),
          );
        },
      ),
    );
  }
}
