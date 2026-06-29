import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _idx = 0;

  final List<_OBSlide> _slides = [
    _OBSlide(
      icon: Icons.bolt,
      title: 'Lightning Fast Delivery',
      desc: 'Food & groceries at your door in 30 mins!',
    ),
    _OBSlide(
      icon: Icons.shopping_basket,
      title: 'Fresh Groceries Too!',
      desc: 'Order vegetables, dairy, staples & more.',
    ),
    _OBSlide(
      icon: Icons.payments_outlined,
      title: 'Easy COD Payments',
      desc: 'Pay cash on delivery. No hassle, no prepayment!',
    ),
  ];

  void _next() {
    if (_idx < 2) {
      setState(() => _idx++);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _slides[_idx];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _SlideContent(slide: s, key: ValueKey(_idx)),
              ),
            ),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == _idx ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _idx ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      child: Text(_idx == 2 ? 'Get Started ⚡' : 'Next'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, AppRoutes.login),
                    child: Text(
                      'Skip',
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _OBSlide {
  final IconData icon;
  final String title;
  final String desc;
  const _OBSlide({required this.icon, required this.title, required this.desc});
}

class _SlideContent extends StatelessWidget {
  final _OBSlide slide;
  const _SlideContent({required this.slide, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(slide.icon, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 48),
          Text(
            slide.title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            slide.desc,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textGrey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
