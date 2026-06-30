import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../providers/app_state_provider.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final user  = state.user;
    final seed  = user?.referCode ?? 'TezDrop';
    final avatarUrl =
        'https://api.dicebear.com/7.x/avataaars/png?seed=$seed';

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Address section
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.addrSelect),
              child: Row(
                children: [
                  Stack(
                    children: [
                      const Icon(Icons.location_on,
                          color: AppColors.primary, size: 22),
                      if (state.liveLocationActive)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 1.2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              state.selectedAddress?.type
                                      .toUpperCase() ??
                                  'HOME',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down,
                                size: 16,
                                color: AppColors.textLight),
                          ],
                        ),
                        Text(
                          state.currentAddress,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textGrey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Action buttons
          Row(
            children: [
              // Notifications
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, AppRoutes.notifications),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF374151)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.notifications_outlined,
                          size: 20, color: AppColors.textGrey),
                      if (state.hasUnread)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Theme toggle
              GestureDetector(
                onTap: () =>
                    context.read<AppStateProvider>().toggleTheme(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF374151)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    state.isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
                    size: 18,
                    color: state.isDark
                        ? AppColors.yellow
                        : AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Avatar
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.profile),
                child: CircleAvatar(
                  radius: 19,
                  backgroundColor: const Color(0xFFFEE2E2),
                  backgroundImage:
                      NetworkImage(avatarUrl),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
