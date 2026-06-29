import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/firebase_service.dart';
import '../../providers/app_state_provider.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});
  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _stars = 4;
  final Set<String> _tags = {};
  final _reviewCtrl = TextEditingController();
  bool _submitting = false;

  static const _labels = ['','Terrible 😞','Bad 😕','Okay 😐','Good 😊','Excellent 🤩'];
  static const _tagOptions = ['Fast Delivery','Hot Food','Good Packaging','Friendly Rider'];

  @override
  void dispose() { _reviewCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final state = context.read<AppStateProvider>();

    await FirebaseService.submitRating({
      'phone'    : state.user?.phone ?? '',
      'stars'    : _stars,
      'tags'     : _tags.toList(),
      'review'   : _reviewCtrl.text.trim(),
      'timestamp': DateTime.now().toString(),
    });

    // FIX #5: Coins actually award hote hain (rating ke baad +5 TezCoins)
    if (state.user != null) {
      state.awardRatingCoins();
    }

    // FIX #8: context.mounted check after async gap
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Review submitted! +5 TezCoins ⭐'),
      backgroundColor: AppColors.green,
      behavior: SnackBarBehavior.floating,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Your Order')),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        const Center(child: Text('🛵', style: TextStyle(fontSize: 64))),
        const SizedBox(height: 16),
        const Center(child: Text('How was your experience?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))),
        const SizedBox(height: 6),
        Center(child: Text('Rate your delivery',
            style: TextStyle(color: AppColors.textGrey))),
        const SizedBox(height: 24),
        // Stars
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) => GestureDetector(
            onTap: () => setState(() => _stars = i + 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.star, size: 40,
                  color: i < _stars ? AppColors.yellow : AppColors.border)),
          )),
        ),
        const SizedBox(height: 8),
        Center(child: Text(_labels[_stars],
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.yellow,
                fontSize: 14))),
        const SizedBox(height: 20),
        // Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _tagOptions.map((t) {
            final on = _tags.contains(t);
            return GestureDetector(
              onTap: () => setState(() {
                if (on) _tags.remove(t); else _tags.add(t);
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: on ? AppColors.primary : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(999)),
                child: Text(t, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: on ? Colors.white : AppColors.textGrey))),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _reviewCtrl,
          maxLines: 4,
          decoration: const InputDecoration(
              hintText: 'Write a review (optional)...')),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Text('Submit Feedback ⭐'),
          ),
        ),
      ]),
    );
  }
}
