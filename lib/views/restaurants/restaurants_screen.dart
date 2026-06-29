import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/restaurant_model.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/app_state_provider.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});
  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  String _sort = 'rating';

  List<RestaurantModel> _sorted(List<RestaurantModel> list) {
    final s = [...list];
    if (_sort == 'rating') {
      s.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sort == 'time') {
      s.sort((a, b) => int.parse(a.time.split(' ')[0])
          .compareTo(int.parse(b.time.split(' ')[0])));
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final rests = _sorted(context.watch<AppStateProvider>().restaurants);

    return Scaffold(
      appBar: AppBar(title: const Text('Top Brands')),
      body: Column(
        children: [
          // Sort chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _SortChip('⭐ Top Rated', 'rating', _sort,
                    () => setState(() => _sort = 'rating')),
                const SizedBox(width: 8),
                _SortChip('⚡ Fastest', 'time', _sort,
                    () => setState(() => _sort = 'time')),
                const SizedBox(width: 8),
                _SortChip('🔄 Default', 'default', _sort,
                    () => setState(() => _sort = 'default')),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.85,
              ),
              itemCount: rests.length,
              itemBuilder: (_, i) {
                final r = rests[i];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context,
                      AppRoutes.restDetail,
                      arguments: {'restId': r.id}),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            child: Center(
                              child: Text(r.image,
                                  style: const TextStyle(fontSize: 48)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: AppColors.yellow, size: 12),
                                  const SizedBox(width: 2),
                                  Text('${r.rating}',
                                      style:
                                          const TextStyle(fontSize: 11)),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.access_time,
                                      size: 12,
                                      color: AppColors.textGrey),
                                  const SizedBox(width: 2),
                                  Text(r.time,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textGrey)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text('Free Delivery',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.green,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label, sortKey, current;
  final VoidCallback onTap;
  const _SortChip(this.label, this.sortKey, this.current, this.onTap);
  @override
  Widget build(BuildContext context) {
    final active = current == sortKey;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label,
            style: TextStyle(
                color: active ? Colors.white : AppColors.textGrey,
                fontWeight: FontWeight.w700,
                fontSize: 12)),
      ),
    );
  }
}
