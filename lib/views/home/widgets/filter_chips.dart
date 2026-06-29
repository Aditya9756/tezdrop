import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/app_state_provider.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Food / Grocery tab
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _TabChip(
                label: '🍕 Food',
                active: state.activeTab == 'food',
                onTap: () =>
                    context.read<AppStateProvider>().setActiveTab('food'),
              ),
              const SizedBox(width: 8),
              _TabChip(
                label: '🛒 Grocery',
                active: state.activeTab == 'grocery',
                onTap: () =>
                    context.read<AppStateProvider>().setActiveTab('grocery'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Veg / Sort filters
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _FilterChip(
                label: 'All',
                active: state.vegFilter == 'all',
                onTap: () => context
                    .read<AppStateProvider>()
                    .setVegFilter('all'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: '🌿 Veg',
                active: state.vegFilter == 'veg',
                onTap: () => context
                    .read<AppStateProvider>()
                    .setVegFilter('veg'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: '🍗 Non-Veg',
                active: state.vegFilter == 'non-veg',
                onTap: () => context
                    .read<AppStateProvider>()
                    .setVegFilter('non-veg'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: '💰 Low Price',
                active: state.sortFilter == 'price',
                onTap: () => context.read<AppStateProvider>()
                    .setSortFilter(state.sortFilter == 'price' ? 'none' : 'price'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: '⭐ Top Rated',
                active: state.sortFilter == 'rating',
                onTap: () => context.read<AppStateProvider>()
                    .setSortFilter(state.sortFilter == 'rating' ? 'none' : 'rating'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabChip(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(999),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.textGrey,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.textGrey,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
