import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state_provider.dart';
import '../home/widgets/product_card.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String restId;
  const RestaurantDetailScreen({super.key, required this.restId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    // FIX #3: restaurants empty hone par crash nahi
    if (state.restaurants.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Restaurant')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🍽️', style: TextStyle(fontSize: 48)),
              SizedBox(height: 12),
              Text('Restaurant not found',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      );
    }

    final restIdx = state.restaurants.indexWhere((r) => r.id == restId);
    final rest    = restIdx >= 0 ? state.restaurants[restIdx] : state.restaurants.first;

    final menu = rest.category.isEmpty
        ? state.products.take(10).toList()
        : state.products
            .where((p) =>
                p.category.toLowerCase().trim() ==
                rest.category.toLowerCase().trim())
            .take(10)
            .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFFF3F4F6),
                child: Center(
                  child: Text(rest.image,
                      style: const TextStyle(fontSize: 80)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rest.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: AppColors.yellow, size: 16),
                      const SizedBox(width: 4),
                      Text('${rest.rating}',
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time,
                          size: 16, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Text(rest.time,
                          style:
                              const TextStyle(color: AppColors.textGrey)),
                      const SizedBox(width: 16),
                      const Text('Free Delivery',
                          style: TextStyle(
                              color: AppColors.green,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Text('Menu',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: menu.isEmpty
                ? const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Text('No menu items available',
                            style: TextStyle(color: AppColors.textGrey)),
                      ),
                    ),
                  )
                : SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => ProductCard(product: menu[i]),
                      childCount: menu.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                  ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}
