import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/app_state_provider.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final offers = [
      {'code': 'TEZDROP50', 'title': '₹50 OFF', 'desc': 'Flat ₹50 off. Min order: ₹99.', 'color': AppColors.primary},
      {'code': 'TEZ20',     'title': 'Flat ₹20 OFF', 'desc': 'On orders above ₹199.', 'color': AppColors.green},
      {'code': 'NEWUSER',   'title': '₹50 OFF', 'desc': 'New users only. Min order ₹149.', 'color': const Color(0xFF7C3AED)},
      {'code': 'GROCERY10', 'title': '₹10 OFF', 'desc': 'On grocery orders above ₹149.', 'color': AppColors.green},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Coupons for You')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: offers.length,
        itemBuilder: (_, i) {
          final o = offers[i]; final c = o['color'] as Color;
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)]),
            child: Row(children: [
              Container(width: 56, decoration: BoxDecoration(color: c, borderRadius: const BorderRadius.horizontal(left: Radius.circular(16))),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: RotatedBox(quarterTurns: 3, child: Text(o['code'] as String,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)))),
              Expanded(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(o['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 3),
                Text(o['desc'] as String, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    final ok = context.read<AppStateProvider>().applyCoupon(o['code'] as String);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(ok ? 'Coupon applied! 🥳' : 'Add items to cart first'),
                      backgroundColor: ok ? AppColors.primary : Colors.red.shade700,
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                  child: Text('TAP TO APPLY', style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ]))),
            ]),
          );
        },
      ),
    );
  }
}
