class AppStrings {
  // Firebase Realtime DB
  // Set via: flutter run --dart-define=FB_URL=https://your-db.firebaseio.com
  static const String firebaseUrl =
      String.fromEnvironment('FB_URL');

  // 2Factor OTP API Key
  // Set via: flutter run --dart-define=OTP_KEY=your-key
  static const String otpApiKey =
      String.fromEnvironment('OTP_KEY');

  // Support
  static const String supportPhone = '+919058055350';
  static const String supportWA    = '919058055350';

  // Coupon codes → discount amount (flat ₹)
  static const Map<String, int> coupons = {
    'TEZDROP50': 50,
    'TEZ20'    : 20,
    'NEWUSER'  : 50,
    'GROCERY10': 10,
  };

  // Coupon rules (min order)
  static const Map<String, int> couponMinOrder = {
    'TEZDROP50': 99,
    'TEZ20'    : 199,
    'NEWUSER'  : 149,
    'GROCERY10': 149,
  };

  // Rider names pool
  static const List<String> riders = [
    'Raju Kumar',
    'Ramesh Singh',
    'Suresh Das',
    'Vinod Yadav',
    'Deepak Sharma',
  ];

  // Avatar seeds for DiceBear
  static const List<String> avatarSeeds = [
    'TezDrop', 'Alpha', 'Beta', 'Gamma', 'Delta', 'Zeta',
  ];

  // App
  static const String appName    = 'TezDrop';
  static const String appTagline = 'Lightning Fast Delivery ⚡';

}
