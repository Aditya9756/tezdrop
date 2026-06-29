import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class OrderLoaderScreen extends StatelessWidget {
  const OrderLoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary),
              ),
            ),
            const SizedBox(height: 28),
            const Text('Placing Order...',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 22)),
            const SizedBox(height: 10),
            Text(
              "Please wait, don't close the app",
              style: TextStyle(color: AppColors.textGrey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
