import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/app_state_provider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final coins = context.watch<AppStateProvider>().user?.coins ?? 0;
    return Scaffold(
      appBar: AppBar(title: const Text('TezWallet')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
                begin: Alignment.centerLeft, end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: const Color(0xFFF59E0B).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0,6))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.monetization_on, color: Colors.white, size: 28),
                const SizedBox(width: 8),
                Text('$coins', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900)),
              ]),
              const SizedBox(height: 4),
              const Text('1 Coin = ₹1 value (max 10% per order)', style: TextStyle(color: Colors.white60, fontSize: 11)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Earn coins by ordering! 🛵'), behavior: SnackBarBehavior.floating)),
                  child: Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: const Text('How to Earn', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 13))),
                )),
                const SizedBox(width: 10),
                Expanded(child: GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: const Text('Transaction History'),
                      content: const Text('Full transaction history coming soon! 🚀\n\nYou earn coins on every order and rating.'),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                    ),
                  ),
                  child: Container(padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                    child: const Text('History', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))))),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
          const Text('Earn More Coins', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _EarnCard(icon: Icons.card_giftcard, iconColor: AppColors.primary, bg: const Color(0xFFFEE2E2),
            title: 'Refer & Earn', sub: 'Get 5 coins per friend', badge: null,
            onTap: () => Navigator.pushNamed(context, AppRoutes.refer)),
          const SizedBox(height: 10),
          _EarnCard(icon: Icons.star_outline, iconColor: AppColors.yellow, bg: const Color(0xFFFFFBEB),
            title: 'Rate Your Order', sub: 'Earn 5 coins per review', badge: '+5',
            onTap: () => Navigator.pushNamed(context, AppRoutes.rating)),
          const SizedBox(height: 10),
          _EarnCard(icon: Icons.shopping_basket_outlined, iconColor: AppColors.green, bg: const Color(0xFFF0FDF4),
            title: 'Order Groceries', sub: 'Earn 1% coins on every order', badge: '1%',
            onTap: () => Navigator.pushNamed(context, AppRoutes.grocery)),
        ],
      ),
    );
  }
}

class _EarnCard extends StatelessWidget {
  final IconData icon; final Color iconColor, bg;
  final String title, sub; final String? badge;
  final VoidCallback onTap;
  const _EarnCard({required this.icon, required this.iconColor, required this.bg,
    required this.title, required this.sub, required this.badge, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Container(width: 46, height: 46, decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 22)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(sub, style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
        ])),
        if (badge != null) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
          child: Text(badge!, style: TextStyle(color: iconColor, fontWeight: FontWeight.bold, fontSize: 12))),
        const SizedBox(width: 6),
        const Icon(Icons.chevron_right, color: AppColors.textLight, size: 18),
      ]),
    ),
  );
}
