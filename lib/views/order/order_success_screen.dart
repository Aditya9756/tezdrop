import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/app_state_provider.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});
  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confetti;
  late AnimationController _scaleCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(
        duration: const Duration(seconds: 4))
      ..play();

    _scaleCtrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600));
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut));
    _scaleCtrl.forward();
  }

  @override
  void dispose() {
    _confetti.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppStateProvider>();
    final order = state.lastOrder;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.brandGradientVertical),
        child: Stack(
          children: [
            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 40,
                colors: const [
                  Colors.white,
                  Color(0xFFFFF59D),
                  Color(0xFFFFCC80),
                  Color(0xFFEF9A9A),
                ],
              ),
            ),
            // Content
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Check icon
                      ScaleTransition(
                        scale: _scale,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.check_rounded,
                              size: 52, color: AppColors.green),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text('Order Placed! 🎉',
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(
                        'Order #${order?.orderId ?? ""}',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Estimated: 25-30 mins',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '💵 Pay Cash on Delivery',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '+${order?.coinsEarned ?? 0} TezCoins earned! 🪙',
                        style: const TextStyle(
                            color: Color(0xFFFDE68A),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      const SizedBox(height: 32),
                      // Track button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.tracking,
                            arguments: {
                              'orderId'   : order?.orderId ?? '',
                              'riderName' : order?.rider ?? '',
                              'riderPhone': order?.riderPhone ?? '',
                            },
                          ),
                          child: const Text('Track Order 🛵',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Back to home
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                                color: Colors.white54),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () =>
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.home,
                                  (_) => false),
                          child: const Text('Back to Home',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
