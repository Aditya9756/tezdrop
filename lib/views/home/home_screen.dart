import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/app_state_provider.dart';
import 'widgets/top_header.dart';
import 'widgets/promo_carousel.dart';
import 'widgets/category_grid.dart';
import 'widgets/restaurant_row.dart';
import 'widgets/product_card.dart';
import 'widgets/filter_chips.dart';
import 'widgets/home_shimmer.dart';
import '../cart/cart_screen.dart';
import '../order/orders_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';

// ── Main Bottom Nav Container ─────────────────────────────
class MainNavigationContainer extends StatefulWidget {
  const MainNavigationContainer({super.key});
  @override
  State<MainNavigationContainer> createState() =>
      _MainNavigationContainerState();
}

class _MainNavigationContainerState extends State<MainNavigationContainer> {
  int _tab = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(index: _tab, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    active: _tab == 0,
                    onTap: () => setState(() => _tab = 0)),
                _NavItem(
                    icon: Icons.search_rounded,
                    label: 'Search',
                    active: _tab == 1,
                    onTap: () => setState(() => _tab = 1)),
                // Cart center button
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tab = 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: const BoxDecoration(
                                gradient: AppColors.brandGradient,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x55EF4444),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.shopping_cart_rounded,
                                  color: Colors.white, size: 24),
                            ),
                            if (state.cartCount > 0)
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${state.cartCount}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _NavItem(
                    icon: Icons.receipt_long_rounded,
                    label: 'Orders',
                    active: _tab == 3,
                    onTap: () => setState(() => _tab = 3)),
                _NavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    active: _tab == 4,
                    onTap: () => setState(() => _tab = 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: active ? AppColors.primary : AppColors.textLight,
                size: 24),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.primary : AppColors.textLight,
                )),
          ],
        ),
      ),
    );
  }
}

// ── Home Screen ───────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AppStateProvider>();
      if (!state.dataLoaded) {
        state.loadData().then((_) => state.restoreCartAfterLoad());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky header
            const TopHeader(),
            // Search bar
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.search),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF374151)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColors.textLight, size: 20),
                    const SizedBox(width: 10),
                    Text('Search food, groceries...',
                        style: TextStyle(
                            color: AppColors.textLight, fontSize: 14)),
                  ],
                ),
              ),
            ),
            // ETA banner
            _EtaBanner(),
            // Content
            Expanded(
              child: state.dataLoaded
                  ? _HomeContent()
                  : const HomeShimmer(),
            ),
          ],
        ),
      ),
    );
  }
}

class _EtaBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final busy = (hour >= 12 && hour <= 14) || (hour >= 19 && hour <= 21);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
                color: AppColors.green, shape: BoxShape.circle),
            child: const Icon(Icons.bolt, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery in ${busy ? "30-40" : "15-25"} mins ⚡',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xFF15803D)),
                ),
                const Text('Free delivery on all orders',
                    style: TextStyle(fontSize: 10, color: Color(0xFF16A34A))),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text('FREE',
                style: TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.w800,
                    fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    if (state.categories.isEmpty && state.restaurants.isEmpty && state.products.isEmpty && state.groceryItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: AppColors.textLight),
            const SizedBox(height: 16),
            const Text('No data available', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('We could not fetch data from Firebase.', style: TextStyle(color: AppColors.textGrey)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        // Promo banners
        const PromoCarousel(),
        const SizedBox(height: 20),
        // Categories
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              Text('Shop by Category',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const CategoryGrid(),
        const SizedBox(height: 20),
        // Tab + filter chips
        const FilterChips(),
        const SizedBox(height: 16),
        // Restaurant row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top Brands',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17)),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, AppRoutes.restaurants),
                child: const Text('View All',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const RestaurantRow(),
        const SizedBox(height: 20),
        // Products grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.activeTab == 'grocery'
                    ? 'Fresh Groceries'
                    : 'Recommended For You',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                state.activeTab == 'grocery'
                    ? 'Delivered in 30 minutes'
                    : 'Fresh food delivered fast',
                style: TextStyle(
                    color: AppColors.textLight, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _ProductsGrid(),
        ),
      ],
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final items = state.filteredProducts;
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text('No items found',
              style: TextStyle(color: AppColors.textLight)),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => ProductCard(product: items[i]),
    );
  }
}
