import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/app_state_provider.dart';

class AddressSelectScreen extends StatelessWidget {
  const AddressSelectScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final addrs = state.addresses;
    return Scaffold(
      appBar: AppBar(title: const Text('Select Delivery Address')),
      body: Stack(children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            // FIX #9: mounted check after async GPS call
            GestureDetector(
              onTap: () async {
                await state.fetchCurrentLocation();
                // context.mounted check — widget still alive hai?
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Using your live location! 📍'),
                  backgroundColor: AppColors.green,
                  behavior: SnackBarBehavior.floating,
                ));
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(children: [
                  Container(
                    width: 40, height: 40,
                    decoration: const BoxDecoration(
                        color: AppColors.green, shape: BoxShape.circle),
                    child: const Icon(Icons.my_location,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Use My Current Location',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF15803D))),
                        Text(
                          state.liveLocationActive
                              ? state.currentAddress
                              : 'Tap to fetch your GPS location',
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF16A34A)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.gps_fixed,
                      color: AppColors.green, size: 22),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            if (addrs.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text('No addresses. Add one below.',
                      style: TextStyle(color: AppColors.textGrey)),
                ),
              )
            else
              ...addrs.asMap().entries.map((entry) {
                final i = entry.key;
                final a = entry.value;
                final isSelected = state.selectedAddress == a;
                return GestureDetector(
                  onTap: () => state.selectAddress(i),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: isSelected ? 2 : 1),
                    ),
                    child: Row(children: [
                      Radio<int>(
                        value: i,
                        groupValue:
                            addrs.indexOf(state.selectedAddress ?? addrs.last),
                        activeColor: AppColors.primary,
                        onChanged: (_) => state.selectAddress(i),
                      ),
                      Icon(
                        a.type == 'work'
                            ? Icons.work_outline
                            : a.type == 'other'
                                ? Icons.location_on_outlined
                                : Icons.home_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.type[0].toUpperCase() + a.type.substring(1),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(a.displayString,
                                style: const TextStyle(
                                    color: AppColors.textGrey, fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ]),
                  ),
                );
              }),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.addAddress),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Add New Address',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            color: Theme.of(context).colorScheme.surface,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (state.selectedAddress == null &&
                      !state.liveLocationActive) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Please select or add a delivery address! 📍'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                    ));
                    return;
                  }
                  if (state.cart.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Pehle kuch items cart mein dalo! 🛒'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                    ));
                    return;
                  }
                  Navigator.pushNamed(context, AppRoutes.payment);
                },
                child: const Text('Proceed to Payment'),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
