import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/product_model.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/app_state_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';
  String _filter = 'all'; // all food grocery veg under99 top

  @override
  void initState() {
    super.initState();
    // Category grid se prefill
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['prefillQuery'] != null) {
        final q = args['prefillQuery'] as String;
        if (q.isNotEmpty) {
          setState(() {
            _query = q;
            _ctrl.text = q;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<ProductModel> _results(AppStateProvider state) {
    if (_query.isEmpty) return [];
    final all = [...state.products, ...state.groceryItems];
    var list = all.where((p) {
      final q = _query.toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
    }).toList();
    if (_filter == 'food')    list = list.where((p) => !p.isGrocery).toList();
    if (_filter == 'grocery') list = list.where((p) => p.isGrocery).toList();
    if (_filter == 'veg')     list = list.where((p) => p.type == 'veg').toList();
    if (_filter == 'under99') list = list.where((p) => p.price < 99).toList();
    if (_filter == 'top')     list = list.where((p) => p.rating >= 4.5).toList();
    return list;
  }

  void _setSearch(String v) {
    setState(() { _query = v; _ctrl.text = v; });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final results = _results(state);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search input bar
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: const Icon(Icons.arrow_back, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.search,
                                color: AppColors.textLight, size: 20),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _ctrl,
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search food, groceries...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13),
                              ),
                              onChanged: (v) => setState(() => _query = v),
                            ),
                          ),
                          if (_query.isNotEmpty)
                            GestureDetector(
                              onTap: () => setState(() {
                                _query = '';
                                _ctrl.clear();
                              }),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Icon(Icons.close,
                                    color: AppColors.textLight, size: 18),
                              ),
                            ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Voice search coming soon! 🎤'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(Icons.mic,
                                  color: AppColors.primary, size: 22),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Filter chips
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                children: [
                  _fChip('All', 'all'),
                  _fChip('🍕 Food', 'food'),
                  _fChip('🛒 Grocery', 'grocery'),
                  _fChip('🌿 Veg', 'veg'),
                  _fChip('Under ₹99', 'under99'),
                  _fChip('⭐ Top Rated', 'top'),
                ],
              ),
            ),
            const Divider(height: 1),
            // Body
            Expanded(
              child: _query.isEmpty
                  ? _PopularSearches(onTap: _setSearch)
                  : results.isEmpty
                      ? _Empty(query: _query)
                      : _ResultsList(results: results),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fChip(String label, String key) {
    final active = _filter == key;
    return GestureDetector(
      onTap: () => setState(() => _filter = key),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label,
            style: TextStyle(
                color: active ? Colors.white : AppColors.textGrey,
                fontWeight: FontWeight.w700,
                fontSize: 11)),
      ),
    );
  }
}

class _PopularSearches extends StatelessWidget {
  final void Function(String) onTap;
  const _PopularSearches({required this.onTap});

  @override
  Widget build(BuildContext context) {
    const tags = [
      '🍕 Pizza', '🍗 Biryani', '🥛 Milk', '🥦 Vegetables',
      '🍔 Burger', '🥚 Eggs', '🌯 Rolls', '🍜 Noodles',
    ];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Popular Searches',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.textGrey,
                  letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map((t) => GestureDetector(
                      onTap: () => onTap(t.split(' ').last),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(t,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  final List<ProductModel> results;
  const _ResultsList({required this.results});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final p = results[i];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.product,
              arguments: {'productId': p.id, 'isGrocery': p.isGrocery}),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(p.image,
                        style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(
                        '${p.category}${p.isGrocery ? " • 🛒" : ""} • ⭐ ${p.rating}',
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                      Text('₹${p.price.toInt()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.primary)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      context.read<AppStateProvider>().addToCart(p),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add,
                        color: AppColors.primary, size: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Empty extends StatelessWidget {
  final String query;
  const _Empty({required this.query});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          const Text('No results found',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 6),
          Text('Try different keywords',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
        ],
      ),
    );
  }
}
