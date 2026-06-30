import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/product_model.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/app_state_provider.dart';
import '../widgets/product_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final bool isGrocery;
  const ProductDetailScreen(
      {super.key, required this.productId, required this.isGrocery});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;
  // Dynamic addOns selection: addOn name → selected bool
  final Map<String, bool> _selectedAddOns = {};

  static const _reviews = [
    {'name': 'Rahul K.', 'stars': 5, 'text': 'Absolutely delicious! Delivered hot and fresh.'},
    {'name': 'Priya S.', 'stars': 4, 'text': 'Good taste, packaging could be better.'},
    {'name': 'Amit T.',  'stars': 5, 'text': 'Best in the area! Will order again.'},
  ];


  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final src   = widget.isGrocery ? state.groceryItems : state.products;

    if (src.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pIdx = src.indexWhere((x) => x.id == widget.productId);
    if (pIdx < 0) {
      // Product not found — show error instead of wrong product
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final p = src[pIdx];

    // Calculate addOns total from product's addOns list
    double addOnsTotal = 0;
    final List<Map<String, dynamic>> activeAddOns = [];
    for (final addOn in p.addOns) {
      final name = addOn['name'] as String? ?? '';
      if (_selectedAddOns[name] == true) {
        final price = (addOn['price'] as num?)?.toDouble() ?? 0.0;
        addOnsTotal += price;
        activeAddOns.add({'name': name, 'price': price});
      }
    }

    final unitPrice  = p.price + addOnsTotal;
    final lineTotal  = unitPrice * _qty;
    final inWish     = state.isWishlisted(p.id);

    // Max qty = stock (clamp between 1 and stock)
    final maxQty = p.stock.clamp(1, 99);

    final related = src
        .where((x) => x.category == p.category && x.id != p.id && !x.isOutOfStock)
        .take(3)
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero image
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: const Color(0xFFF3F4F6),
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
                actions: [
                  GestureDetector(
                    onTap: () => state.toggleWish(p.id),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        inWish ? Icons.favorite : Icons.favorite_border,
                        color: inWish ? AppColors.primary : Colors.black,
                        size: 18,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: ProductImage(
                    image: p.image,
                    size: double.infinity,
                    emojiFontSize: 100,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name + veg/nonveg badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(p.name,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: p.type == 'veg'
                                      ? const Color(0xFFF0FDF4)
                                      : const Color(0xFFFFF1F1),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: p.type == 'veg'
                                        ? AppColors.green
                                        : AppColors.primary,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.circle,
                                        size: 8,
                                        color: p.type == 'veg'
                                            ? AppColors.green
                                            : AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      p.type == 'veg' ? 'VEG' : 'NON-VEG',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: p.type == 'veg'
                                              ? AppColors.green
                                              : AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Rating
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: AppColors.yellow, size: 16),
                              const SizedBox(width: 4),
                              Text('${p.rating}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              const SizedBox(width: 4),
                              Text('(${(p.rating * 28).toInt()} ratings)',
                                  style: const TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Price row
                          Row(
                            children: [
                              Text(
                                '₹${unitPrice.toInt()}',
                                style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary),
                              ),
                              if (p.oldPrice > p.price) ...[
                                const SizedBox(width: 10),
                                Text(
                                  '₹${p.oldPrice.toInt()}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textLight,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDF4),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '${p.discountPercent}% OFF',
                                    style: const TextStyle(
                                        color: AppColors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11),
                                  ),
                                ),
                              ],
                              if (p.unit != null) ...[
                                const SizedBox(width: 8),
                                Text(' / ${p.unit}',
                                    style: const TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 13)),
                              ],
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Stock banner
                          _StockBanner(product: p),
                          const SizedBox(height: 16),

                          // Description
                          const Text('Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 6),
                          Text(p.desc,
                              style: const TextStyle(
                                  color: AppColors.textGrey,
                                  height: 1.6,
                                  fontSize: 13)),
                          const SizedBox(height: 20),

                          // === DYNAMIC ADD-ONS SECTION ===
                          // Only shows if vendor has set addOns for this product
                          // Grocery items mein addOns nahi hote
                          if (!widget.isGrocery && p.hasAddOns) ...[
                            const Text('Customise',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                children: p.addOns.map((addOn) {
                                  final name = addOn['name'] as String? ?? '';
                                  final price = (addOn['price'] as num?)?.toDouble() ?? 0.0;
                                  final isSelected = _selectedAddOns[name] == true;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          name.contains('Cheese') ? '🧀' :
                                          name.contains('Sauce')  ? '🥣' :
                                          name.contains('Spicy')  ? '🌶️' :
                                          name.contains('Paneer') ? '🧆' : '➕',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(name,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 13)),
                                              Text('+₹${price.toInt()}',
                                                  style: const TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        Switch(
                                          value: isSelected,
                                          activeColor: AppColors.primary,
                                          onChanged: (v) => setState(() =>
                                              _selectedAddOns[name] = v),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Reviews
                          const Text('Reviews',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 10),
                          ..._reviews.map((r) => _ReviewTile(review: r)),
                          const SizedBox(height: 20),

                          // Related items
                          if (related.isNotEmpty) ...[
                            const Text('You May Also Like',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 120,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: related.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (_, i) {
                                  final r = related[i];
                                  return GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      AppRoutes.product,
                                      arguments: {
                                        'productId': r.id,
                                        'isGrocery': r.isGrocery,
                                      },
                                    ),
                                    child: Container(
                                      width: 110,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ProductImage(
                                            image: r.image,
                                            size: 48,
                                            emojiFontSize: 28,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(r.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold)),
                                          Text('₹${r.price.toInt()}',
                                              style: const TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],

                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom bar — qty + add to cart
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Qty control
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _QBtn(
                          icon: Icons.remove,
                          onTap: () {
                            if (_qty > 1) setState(() => _qty--);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text('$_qty',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        _QBtn(
                          icon: Icons.add,
                          onTap: () {
                            if (_qty < maxQty) setState(() => _qty++);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Add to cart
                  Expanded(
                    child: GestureDetector(
                      onTap: p.isOutOfStock
                          ? null
                          : () {
                              for (int i = 0; i < _qty; i++) {
                                state.addToCart(p, selectedAddOns: activeAddOns);
                              }
                              if (mounted) Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    activeAddOns.isEmpty
                                        ? '${p.name} added to cart! 🛒'
                                        : '${p.name} (+${activeAddOns.map((a) => a['name']).join(', ')}) added! 🛒',
                                  ),
                                  backgroundColor: AppColors.primary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: p.isOutOfStock ? null : AppColors.brandGradient,
                          color: p.isOutOfStock ? AppColors.border : null,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: p.isOutOfStock
                              ? null
                              : [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_cart_outlined,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              p.isOutOfStock
                                  ? 'Out of Stock'
                                  : 'Add to Cart — ₹${lineTotal.toInt()}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewTile({required this.review});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(review['name'] as String,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              const Spacer(),
              ...List.generate(
                review['stars'] as int,
                (_) => const Icon(Icons.star, color: AppColors.yellow, size: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(review['text'] as String,
              style: const TextStyle(
                  color: AppColors.textGrey, fontSize: 12, height: 1.5)),
        ],
      ),
    );
  }
}

class _StockBanner extends StatelessWidget {
  final ProductModel product;
  const _StockBanner({required this.product});
  @override
  Widget build(BuildContext context) {
    if (product.isOutOfStock) {
      return _Banner(
          icon: Icons.cancel_outlined,
          text: 'Out of Stock — Check back soon!',
          color: const Color(0xFFFFF1F2),
          iconColor: AppColors.primary);
    }
    if (product.isLowStock) {
      return _Banner(
          icon: Icons.warning_amber_rounded,
          text: 'Only ${product.stock} left! Order fast 🔥',
          color: const Color(0xFFFFF7ED),
          iconColor: AppColors.secondary);
    }
    return _Banner(
        icon: Icons.check_circle_outline,
        text: 'In Stock ✅ Delivery in 20-30 mins',
        color: const Color(0xFFF0FDF4),
        iconColor: AppColors.green);
  }
}

class _Banner extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color, iconColor;
  const _Banner(
      {required this.icon,
      required this.text,
      required this.color,
      required this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ),
        ],
      ),
    );
  }
}