import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/otp_service.dart';
import '../../providers/app_state_provider.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpCtrl = TextEditingController();
  bool _loading = false;
  int _resend = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResend();
  }

  void _startResend() {
    _resend = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resend <= 0) {
        t.cancel();
      } else {
        setState(() => _resend--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  Future<void> _verify() async {
    if (_otpCtrl.text.length != 6) {
      _snack('Enter complete 6-digit OTP');
      return;
    }
    setState(() => _loading = true);

    final state   = context.read<AppStateProvider>();
    final session = state.otpSession ?? '';
    bool ok       = false;

    // Dev mode disabled in production
    if (false) {
      ok = true;
    } else {
      ok = await OtpService.verifyOtp(session, _otpCtrl.text);
    }

    setState(() => _loading = false);

    if (!ok) {
      _snack('Wrong OTP! Try again.');
      return;
    }

    // Check if existing user
    final phone = '+91 ${widget.phone}';
    if (state.user != null && state.user!.phone == phone) {
      await state.loadData();
      state.restoreCartAfterLoad();
      if (mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    } else {
      _showNameDialog(phone);
    }
  }

  void _showNameDialog(String phone) {
    final nameCtrl  = TextEditingController();
    final emailCtrl = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Column(
          children: [
            Text('👋', style: TextStyle(fontSize: 40)),
            SizedBox(height: 8),
            Text('Welcome to TezDrop!',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Apna naam batao',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(hintText: 'Full Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(hintText: 'Email (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _finishLogin(phone, 'User_${widget.phone.substring(widget.phone.length - 4)}', '');
            },
            child: Text('Skip', style: TextStyle(color: AppColors.textGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              final n = nameCtrl.text.trim();
              if (n.isEmpty) return;
              Navigator.pop(context);
              _finishLogin(phone, n, emailCtrl.text.trim());
            },
            child: const Text('Start Ordering ⚡'),
          ),
        ],
      ),
    );
  }

  Future<void> _finishLogin(String phone, String name, String email) async {
    final state = context.read<AppStateProvider>();
    state.createUser(phone, name, email: email);
    await state.loadData();
    state.restoreCartAfterLoad();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
      _snack('Welcome to TezDrop! 🎉 +10 Bonus Coins!');
    }
  }

  Future<void> _resendOtp() async {
    final session = await OtpService.sendOtp(widget.phone);
    if (session != null) {
      context.read<AppStateProvider>().setOtpSession(session);
      _snack('OTP Resent! 📲');
    } else {
      // Dev hint removed
    }
    _startResend();
  }

  @override
  Widget build(BuildContext context) {
    final defaultTheme = PinTheme(
      width: 52,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent, width: 2),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              const SizedBox(height: 32),
              const Text('Verify OTP',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                  children: [
                    const TextSpan(text: 'Sent to '),
                    TextSpan(
                      text: '+91 ${widget.phone}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Pinput(
                controller: _otpCtrl,
                length: 6,
                defaultPinTheme: defaultTheme,
                focusedPinTheme: defaultTheme.copyDecorationWith(
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                onCompleted: (_) => _verify(),
              ),
              const SizedBox(height: 24),
              Center(
                child: _resend > 0
                    ? RichText(
                        text: TextSpan(
                          style: TextStyle(
                              color: AppColors.textGrey, fontSize: 13),
                          children: [
                            const TextSpan(text: 'Resend in '),
                            TextSpan(
                              text:
                                  '00:${_resend.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: _resendOtp,
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
              ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _verify,
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('Verify & Proceed'),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
