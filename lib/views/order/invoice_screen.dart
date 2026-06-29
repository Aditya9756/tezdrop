import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state_provider.dart';

class InvoiceScreen extends StatelessWidget {
  final String orderId;
  const InvoiceScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final orders = context.read<AppStateProvider>().orders;

    // FIX #2: orders empty hone par crash nahi — safe guard
    if (orders.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Invoice')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🧾', style: TextStyle(fontSize: 48)),
              SizedBox(height: 12),
              Text('Invoice not available',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 6),
              Text('No orders found', style: TextStyle(color: AppColors.textGrey)),
            ],
          ),
        ),
      );
    }

    final orderIdx = orders.indexWhere((o) => o.orderId == orderId);
    if (orderIdx < 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Invoice')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🧾', style: TextStyle(fontSize: 48)),
              SizedBox(height: 12),
              Text('Invoice not found',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 6),
              Text('This order invoice is not available.',
                  style: TextStyle(color: AppColors.textGrey)),
            ],
          ),
        ),
      );
    }
    final order = orders[orderIdx];

    return Scaffold(
      appBar: AppBar(title: const Text('Order Invoice')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
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
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColors.brandGradient.createShader(bounds),
                          child: const Text('TezDrop',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white)),
                        ),
                        const Text('⚡ Food & Grocery Delivery',
                            style: TextStyle(
                                color: AppColors.textGrey, fontSize: 11)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('INVOICE',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: 2,
                                color: AppColors.primary)),
                        Text('#${order.orderId}',
                            style: const TextStyle(
                                color: AppColors.textGrey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),

                // Order info
                _InfoRow('Date', order.timestamp.substring(0, 10)),
                _InfoRow('Delivery To', order.address),
                _InfoRow('Payment', order.payment),
                _InfoRow('Status', order.status),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),

                // Items
                const Text('Items Ordered',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(item.image,
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13)),
                                Text('₹${item.price.toInt()} × ${item.qty}',
                                    style: const TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          Text(
                            '₹${(item.price * item.qty).toInt()}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),

                // Bill
                if (order.coinsUsed > 0)
                  _BillRow('Coins Used', '-₹${order.coinsUsed}',
                      color: AppColors.yellow),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Paid',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('₹${order.total.toInt()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 8),
                if (order.coinsEarned > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on,
                            color: AppColors.yellow, size: 16),
                        const SizedBox(width: 6),
                        Text('+${order.coinsEarned} TezCoins earned!',
                            style: const TextStyle(
                                color: AppColors.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: AppColors.green, size: 16),
                SizedBox(width: 8),
                Text('Thank you for ordering with TezDrop! ⚡',
                    style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.textGrey, fontSize: 12)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label, value;
  final Color? color;
  const _BillRow(this.label, this.value, {this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textGrey, fontSize: 13)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: color ?? Colors.black)),
        ],
      ),
    );
  }
}
