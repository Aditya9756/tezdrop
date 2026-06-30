import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Banner
          _box(double.infinity, 160, radius: 20),
          const SizedBox(height: 20),
          // Category row
          Row(
            children: List.generate(
                5,
                (_) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          _box(60, 60, radius: 18),
                          const SizedBox(height: 6),
                          _box(50, 10, radius: 6),
                        ],
                      ),
                    )),
          ),
          const SizedBox(height: 20),
          // Restaurant row
          Row(
            children: List.generate(
                3,
                (_) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _box(130, 150, radius: 16),
                    )),
          ),
          const SizedBox(height: 20),
          // Product grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.72,
            ),
            itemCount: 6,
            itemBuilder: (_, __) => _box(double.infinity, 220, radius: 18),
          ),
        ],
      ),
    );
  }

  Widget _box(double w, double h, {double radius = 8}) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}
