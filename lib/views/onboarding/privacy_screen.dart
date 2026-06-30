import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.bolt, color: AppColors.primary, size: 28),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TezDrop',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Lightning Fast Delivery ⚡',
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _section('1. Introduction',
              'TezDrop provides food and grocery delivery services. By using our app, you agree to these Terms of Service and Privacy Policy. Please read them carefully before placing any order.'),
          _section('2. Data We Collect', null, bullets: [
            'Mobile number (for OTP login and order updates)',
            'Delivery address and GPS location',
            'Order history and preferences',
            'Device information for app performance',
          ]),
          _section('3. How We Use Your Data', null, bullets: [
            'To process and deliver your orders',
            'To send order status notifications via SMS/WhatsApp',
            'To improve app experience and recommendations',
            'We never sell your data to third parties',
          ]),
          _section('4. Orders & Payments',
              'TezDrop currently supports Cash on Delivery (COD) only. All prices are inclusive of taxes. Delivery is free on all orders.'),
          _section('5. Cancellation & Refunds',
              'You may cancel your order before a delivery partner is assigned. Refunds for prepaid orders will be processed within 5-7 business days.'),
          _section('6. Delivery Policy',
              'We aim to deliver within 25-30 minutes. Delivery time may vary based on weather, traffic, or high demand.'),
          _section('7. TezCoins (Loyalty Points)',
              'TezCoins are loyalty points earned on every order. 1 TezCoin = ₹1 discount. Maximum 10% of order value can be paid using TezCoins.'),
          _section('8. Contact Us', null, contact: true),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Last updated: June 2026 • TezDrop, India',
              style: TextStyle(color: AppColors.textLight, fontSize: 11),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('I Agree & Continue ✅'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _section(String title, String? body,
      {List<String>? bullets, bool contact = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          if (body != null)
            Text(body,
                style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 13,
                    height: 1.6)),
          if (bullets != null)
            ...bullets.map((b) => Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ',
                          style: TextStyle(color: AppColors.primary)),
                      Expanded(
                        child: Text(b,
                            style: const TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 13,
                                height: 1.5)),
                      ),
                    ],
                  ),
                )),
          if (contact)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📞 +91 90580 55350',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('💬 WhatsApp: wa.me/919058055350',
                      style: TextStyle(
                          color: AppColors.textGrey, fontSize: 13)),
                  SizedBox(height: 4),
                  Text('🕐 Support hours: 9 AM – 10 PM daily',
                      style: TextStyle(
                          color: AppColors.textGrey, fontSize: 13)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
