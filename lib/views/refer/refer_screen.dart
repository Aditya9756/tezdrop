import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state_provider.dart';

class ReferScreen extends StatelessWidget {
  const ReferScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final code = context.watch<AppStateProvider>().user?.referCode ?? 'TEZDROP';
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.brandGradientVertical),
        child: SafeArea(child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(16,12,16,0), child: Row(children: [
            GestureDetector(onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.white)),
            const SizedBox(width: 12),
            const Text('Refer & Earn', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ])),
          Expanded(child: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 120, height: 120, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Center(child: Text('🎁', style: TextStyle(fontSize: 60)))),
              const SizedBox(height: 28),
              const Text('Get 5 TezCoins!', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text('Invite friends to TezDrop. When they place their first order, you get 5 TezCoins!',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14, height: 1.5)),
              const SizedBox(height: 28),
              Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white30)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(code, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: 2)),
                  GestureDetector(
                    onTap: () { Clipboard.setData(ClipboardData(text: code));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code copied! 📋'), behavior: SnackBarBehavior.floating)); },
                    child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: const Text('COPY', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                  ),
                ])),
              const SizedBox(height: 20),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () => Share.share('Hey! Use my code $code on TezDrop and get ₹50 OFF on your first order! 🎉\nDownload: https://tezdrop.in'),
                icon: const Text('📱'),
                label: const Text('Share with Friends', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              )),
            ],
          )))),
        ])),
      ),
    );
  }
}
