import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../providers/app_state_provider.dart';

class RestaurantRow extends StatelessWidget {
  const RestaurantRow({super.key});

  @override
  Widget build(BuildContext context) {
    final rests = context.watch<AppStateProvider>().restaurants;
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: rests.length,
        itemBuilder: (_, i) {
          final r = rests[i];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.restDetail,
                arguments: {'restId': r.id}),
            child: Container(
              width: 130,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                    ),
                    child: Center(
                      child: Text(r.image,
                          style: const TextStyle(fontSize: 40)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: AppColors.yellow, size: 12),
                            const SizedBox(width: 2),
                            Text('${r.rating}',
                                style: const TextStyle(fontSize: 10)),
                            const SizedBox(width: 4),
                            const Text('•',
                                style: TextStyle(color: AppColors.textLight)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(r.time,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textGrey),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
