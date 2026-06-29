import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/app_state_provider.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final addrs = state.addresses;
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Addresses')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (addrs.isEmpty)
            Center(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text('No saved addresses yet.', style: TextStyle(color: AppColors.textGrey)),
            ))
          else
            ...addrs.asMap().entries.map((entry) {
              final i = entry.key; final a = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Row(children: [
                  Icon(a.type == 'work' ? Icons.work_outline : a.type == 'other' ? Icons.location_on_outlined : Icons.home_outlined,
                    color: AppColors.primary, size: 22),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(a.type[0].toUpperCase() + a.type.substring(1),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 3),
                    Text(a.displayString, style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  ])),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.primary, size: 20),
                    onPressed: () => state.removeAddress(i)),
                ]),
              );
            }),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.addAddress),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add, color: AppColors.primary),
                SizedBox(width: 8),
                Text('Add New Address', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
