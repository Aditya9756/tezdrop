import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state_provider.dart';
import '../home/widgets/product_card.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});
  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  final _cats = ['all', 'Vegetables', 'Fruits', 'Dairy', 'Staples', 'Snacks'];
  final _labels = {
    'all': 'All', 'Vegetables': '🥦 Vegetables', 'Fruits': '🍎 Fruits',
    'Dairy': '🥛 Dairy', 'Staples': '🌾 Staples', 'Snacks': '🍿 Snacks',
  };

  @override
  Widget build(BuildContext context) {
    final state  = context.watch<AppStateProvider>();
    final filter = state.groceryFilter;
    final items  = state.filteredGrocery;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fresh Groceries 🛒',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Delivered in 30 mins',
                style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Category filter chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: _cats.map((c) {
                final active = filter == c;
                return GestureDetector(
                  onTap: () => context
                      .read<AppStateProvider>()
                      .setGroceryFilter(c),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.green
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(_labels[c] ?? c,
                        style: TextStyle(
                            color: active ? Colors.white : AppColors.textGrey,
                            fontWeight: FontWeight.w700,
                            fontSize: 12)),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          // Grid
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text('No items found',
                        style: TextStyle(color: AppColors.textGrey)))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, i) =>
                        ProductCard(product: items[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
