import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/app_state_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final user  = state.user;
    final seed  = user?.referCode ?? 'TezDrop';

    return Scaffold(
      body: user == null
          ? _NotLoggedIn()
          : CustomScrollView(
              slivers: [
                // Red header
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(40)),
                    ),
                    padding: EdgeInsets.fromLTRB(
                        20,
                        MediaQuery.of(context).padding.top + 20,
                        20,
                        60),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          children: [
                            // Avatar
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 42,
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.3),
                                  backgroundImage: NetworkImage(
                                    'https://api.dicebear.com/7.x/avataaars/png?seed=$seed',
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                        context, AppRoutes.editProfile),
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: const Icon(Icons.edit,
                                          color: AppColors.primary,
                                          size: 13),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(user.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(user.phone,
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.75),
                                    fontSize: 13)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.monetization_on,
                                      color: Color(0xFFFDE68A), size: 18),
                                  const SizedBox(width: 6),
                                  Text('${user.coins} TezCoins',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Stats row
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                _Stat(
                                  icon: Icons.monetization_on,
                                  iconColor: AppColors.yellow,
                                  label: '${user.coins}',
                                  sub: 'Coins',
                                  onTap: () => Navigator.pushNamed(
                                      context, AppRoutes.wallet),
                                ),
                                _Divider(),
                                _Stat(
                                  icon: Icons.favorite,
                                  iconColor: AppColors.primary,
                                  label: '${state.wishlist.length}',
                                  sub: 'Wishlist',
                                  onTap: () => Navigator.pushNamed(
                                      context, AppRoutes.wishlist),
                                ),
                                _Divider(),
                                _Stat(
                                  icon: Icons.receipt_long,
                                  iconColor: AppColors.blue,
                                  label: '${state.orders.length}',
                                  sub: 'Orders',
                                  onTap: () => Navigator.pushNamed(
                                      context, AppRoutes.orders),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Menu items
                          _MenuCard(items: [
                            _MenuItem(Icons.account_balance_wallet,
                                'TezWallet', AppColors.yellow,
                                () => Navigator.pushNamed(
                                    context, AppRoutes.wallet)),
                            _MenuItem(Icons.person_outline,
                                'Edit Profile', AppColors.blue,
                                () => Navigator.pushNamed(
                                    context, AppRoutes.editProfile)),
                            _MenuItem(Icons.map_outlined,
                                'Saved Addresses', AppColors.blue,
                                () => Navigator.pushNamed(
                                    context, AppRoutes.addresses)),
                            _MenuItem(Icons.local_offer_outlined,
                                'Offers & Coupons', AppColors.secondary,
                                () => Navigator.pushNamed(
                                    context, AppRoutes.offers)),
                            _MenuItem(Icons.card_giftcard,
                                'Refer & Earn', AppColors.primary,
                                () => Navigator.pushNamed(
                                    context, AppRoutes.refer)),
                            _MenuItem(Icons.notifications_outlined,
                                'Notifications', AppColors.green,
                                () => Navigator.pushNamed(
                                    context, AppRoutes.notifications)),
                            _MenuItem(
                              state.isDark
                                  ? Icons.wb_sunny_outlined
                                  : Icons.dark_mode_outlined,
                              'Dark Mode',
                              AppColors.textGrey,
                              () => state.toggleTheme(),
                              trailing: Switch(
                                value: state.isDark,
                                activeColor: AppColors.primary,
                                onChanged: (_) => state.toggleTheme(),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 14),

                          _MenuCard(items: [
                            _MenuItem(Icons.headset_mic_outlined,
                                'Help & Support', AppColors.green,
                                () => Navigator.pushNamed(
                                    context, AppRoutes.support)),
                            _MenuItem(Icons.power_settings_new,
                                'Logout', AppColors.primary,
                                () => _confirmLogout(context, state),
                                isRed: true),
                          ]),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _confirmLogout(BuildContext ctx, AppStateProvider state) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout?'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(ctx);
              state.logout();
              Navigator.pushNamedAndRemoveUntil(
                  ctx, AppRoutes.login, (_) => false);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _NotLoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_outline,
              size: 72, color: AppColors.border),
          const SizedBox(height: 16),
          const Text('Not logged in',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.login),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label, sub;
  final VoidCallback onTap;
  const _Stat(
      {required this.icon,
      required this.iconColor,
      required this.label,
      required this.sub,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13)),
            Text(sub,
                style: const TextStyle(
                    color: AppColors.textGrey, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 40, color: AppColors.border);
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuCard({required this.items});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final i    = e.key;
          final item = e.value;
          return Column(
            children: [
              GestureDetector(
                onTap: item.onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 13),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color:
                              item.iconColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item.icon,
                            color: item.iconColor, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(item.label,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: item.isRed
                                    ? AppColors.primary
                                    : null)),
                      ),
                      item.trailing ??
                          Icon(Icons.chevron_right,
                              color: AppColors.textLight, size: 18),
                    ],
                  ),
                ),
              ),
              if (i < items.length - 1)
                Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: AppColors.border),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isRed;
  final Widget? trailing;
  const _MenuItem(this.icon, this.label, this.iconColor, this.onTap,
      {this.isRed = false, this.trailing});
}
