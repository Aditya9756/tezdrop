import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/order_model.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/firebase_service.dart';
import '../../providers/app_state_provider.dart';
import '../widgets/product_image.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await context.read<AppStateProvider>().loadOrders();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _cancelOrder(OrderModel order) async {
    if (order.firebaseKey == null) return;

    // Confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Order?'),
        content: const Text('Are you sure you want to cancel this order? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No, Keep'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final ok = await FirebaseService.updateOrderStatus(order.firebaseKey!, 'Cancelled');
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Order cancelled ✅'),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
      ));
      _load();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cannot cancel. Call: 90580 55350'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  void _reorder(BuildContext context, OrderModel order) {
    final state = context.read<AppStateProvider>();
    for (final item in order.items) {
      final allProds = [
        ...state.products,
        ...state.groceryItems
      ];
      final prod = allProds
          .where((p) => p.id == item.id)
          .firstOrNull;
      if (prod != null && !prod.isOutOfStock) {
        for (int i = 0; i < item.qty; i++) {
          state.addToCart(prod);
        }
      }
    }
    Navigator.pushNamed(context, AppRoutes.cart);
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<AppStateProvider>().orders;

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? _Empty()
              : RefreshIndicator(
                  onRefresh: _load,
                  color: AppColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (_, i) =>
                        _OrderCard(
                          order: orders[i],
                          onReorder: () => _reorder(context, orders[i]),
                          onCancel:  () => _cancelOrder(orders[i]),
                        ),
                  ),
                ),
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt_long_outlined,
              size: 72, color: AppColors.border),
          const SizedBox(height: 16),
          const Text('No orders yet',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text('Order something delicious!',
              style: TextStyle(color: AppColors.textGrey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.home),
            child: const Text('Order Now'),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onReorder, onCancel;
  const _OrderCard(
      {required this.order,
      required this.onReorder,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final statusColor = order.status == 'Cancelled'
        ? AppColors.primary
        : order.status == 'Delivered'
            ? AppColors.green
            : AppColors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(order.status.toUpperCase(),
                              style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10)),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('COD',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(order.timestamp,
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textGrey)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('₹${order.total.toInt()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primary)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.invoice,
                          arguments: {'orderId': order.orderId}),
                      child: Text(order.orderId,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primary)),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 18),
            // Item thumbnails (real vendor photos or emoji fallback)
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: order.items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => ProductImage(
                  image: order.items[i].image,
                  size: 44,
                  emojiFontSize: 22,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Items summary
            Text(
              order.items
                  .map((i) =>
                      '${i.name} ×${i.qty}${i.isGrocery ? " 🛒" : ""}')
                  .join(', '),
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: _ActionBtn(
                    label: 'Reorder 🔄',
                    color: const Color(0xFFFEE2E2),
                    textColor: AppColors.primary,
                    onTap: onReorder,
                  ),
                ),
                const SizedBox(width: 8),
                if (order.status != 'Cancelled' && order.status != 'Delivered')
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _ActionBtn(
                        label: 'Track 🛵',
                        color: const Color(0xFFF3F4F6),
                        textColor: AppColors.textGrey,
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.tracking,
                            arguments: {
                              'orderId'   : order.orderId,
                              'riderName' : order.rider,
                              'riderPhone': order.riderPhone,
                            }),
                      ),
                    ),
                  ),
                Expanded(
                  child: _ActionBtn(
                    label: 'Rate ⭐',
                    color: const Color(0xFFF3F4F6),
                    textColor: AppColors.textGrey,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.rating),
                  ),
                ),
              ],
            ),
            if (order.status != 'Cancelled' &&
                order.status != 'Delivered') ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onCancel,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFFFECACA)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.close,
                          size: 14, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text('Cancel Order',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color, textColor;
  final VoidCallback onTap;
  const _ActionBtn(
      {required this.label,
      required this.color,
      required this.textColor,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: textColor)),
      ),
    );
  }
}
