import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/product_model.dart';
import '../../../core/routes/app_routes.dart';
import '../../../providers/app_state_provider.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final state     = context.watch<AppStateProvider>();
    final inWish    = state.isWishlisted(product.id);
    final cartQty   = state.cartQtyFor(product.id);
    final outOfStock = product.isOutOfStock;
    final lowStock   = product.isLowStock;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.product,
        arguments: {
          'productId': product.id,
          'isGrocery': product.isGrocery,
        },
      ),
      child: Opacity(
        opacity: outOfStock ? 0.65 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image area
                  Stack(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(18)),
                        ),
                        child: Center(
                          child: Text(product.image,
                              style: const TextStyle(fontSize: 52)),
                        ),
                      ),
                      // Stock badge
                      if (outOfStock)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: _Badge('Out of Stock',
                              const Color(0xFF374151)),
                        )
                      else if (lowStock)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: _Badge(
                              'Only ${product.stock} left!',
                              AppColors.secondary),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Veg dot + category
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: product.type == 'veg'
                                      ? AppColors.green
                                      : AppColors.primary,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Center(
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: product.type == 'veg'
                                        ? AppColors.green
                                        : AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                product.category.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textLight,
                                    letterSpacing: 0.5),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (product.isGrocery && product.unit != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(product.unit!,
                                    style: const TextStyle(
                                        fontSize: 9,
                                        color: AppColors.green,
                                        fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Name
                        Text(
                          product.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // Price + add button
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text('₹${product.price.toInt()}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                        color: AppColors.primary)),
                                Text('₹${product.oldPrice.toInt()}',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textLight,
                                        decoration:
                                            TextDecoration.lineThrough)),
                              ],
                            ),
                            // Add / qty control
                            if (outOfStock)
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.block,
                                    size: 14,
                                    color: AppColors.textLight),
                              )
                            else if (cartQty > 0)
                              _QtyControl(product: product)
                            else
                              GestureDetector(
                                onTap: () => context
                                    .read<AppStateProvider>()
                                    .addToCart(product),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEE2E2),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.add,
                                      color: AppColors.primary, size: 18),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Wishlist button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => context
                      .read<AppStateProvider>()
                      .toggleWish(product.id),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4),
                      ],
                    ),
                    child: Icon(
                      inWish ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color:
                          inWish ? AppColors.primary : AppColors.textLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold)),
    );
  }
}

class _QtyControl extends StatelessWidget {
  final ProductModel product;
  const _QtyControl({required this.product});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final qty   = state.cartQtyFor(product.id);
    return Container(
      height: 28,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () =>
                context.read<AppStateProvider>().removeFromCart(product),
            child: const SizedBox(
                width: 24,
                child: Icon(Icons.remove,
                    size: 14, color: AppColors.primary)),
          ),
          Text('$qty',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12)),
          GestureDetector(
            onTap: () =>
                context.read<AppStateProvider>().addToCart(product),
            child: const SizedBox(
                width: 24,
                child: Icon(Icons.add,
                    size: 14, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
