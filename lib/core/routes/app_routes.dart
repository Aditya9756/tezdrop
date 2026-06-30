import 'package:flutter/material.dart';

// Views imports
import '../../views/onboarding/splash_screen.dart';
import '../../views/onboarding/onboarding_screen.dart';
import '../../views/onboarding/login_screen.dart';
import '../../views/onboarding/otp_screen.dart';
import '../../views/onboarding/privacy_screen.dart';
import '../../views/home/home_screen.dart';
import '../../views/search/search_screen.dart';
import '../../views/grocery/grocery_screen.dart';
import '../../views/restaurants/restaurants_screen.dart';
import '../../views/restaurants/restaurant_detail_screen.dart';
import '../../views/product/product_detail_screen.dart';
import '../../views/wishlist/wishlist_screen.dart';
import '../../views/cart/cart_screen.dart';
import '../../views/address/address_list_screen.dart';
import '../../views/address/address_select_screen.dart';
import '../../views/address/add_address_screen.dart';
import '../../views/payment/payment_screen.dart';
import '../../views/order/order_loader_screen.dart';
import '../../views/order/order_success_screen.dart';
import '../../views/order/order_tracking_screen.dart';
import '../../views/order/orders_screen.dart';
import '../../views/order/invoice_screen.dart';
import '../../views/profile/profile_screen.dart';
import '../../views/profile/edit_profile_screen.dart';
import '../../views/wallet/wallet_screen.dart';
import '../../views/offers/offers_screen.dart';
import '../../views/refer/refer_screen.dart';
import '../../views/notifications/notifications_screen.dart';
import '../../views/rating/rating_screen.dart';
import '../../views/support/support_screen.dart';

class AppRoutes {
  // Route names
  static const String splash        = '/';
  static const String onboarding    = '/onboarding';
  static const String login         = '/login';
  static const String otp           = '/otp';
  static const String privacy       = '/privacy';
  static const String home          = '/home';
  static const String search        = '/search';
  static const String grocery       = '/grocery';
  static const String restaurants   = '/restaurants';
  static const String restDetail    = '/rest-detail';
  static const String product       = '/product';
  static const String wishlist      = '/wishlist';
  static const String cart          = '/cart';
  static const String addresses     = '/addresses';
  static const String addrSelect    = '/addr-select';
  static const String addAddress    = '/add-address';
  static const String payment       = '/payment';
  static const String orderLoader   = '/order-loader';
  static const String orderSuccess  = '/order-success';
  static const String tracking      = '/tracking';
  static const String orders        = '/orders';
  static const String invoice       = '/invoice';
  static const String profile       = '/profile';
  static const String editProfile   = '/edit-profile';
  static const String wallet        = '/wallet';
  static const String offers        = '/offers';
  static const String refer         = '/refer';
  static const String notifications = '/notifications';
  static const String rating        = '/rating';
  static const String support       = '/support';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>? ?? {};

    switch (settings.name) {
      case splash:
        return _fade(const SplashScreen(), settings);
      case onboarding:
        return _fade(const OnboardingScreen(), settings);
      case login:
        return _fade(const LoginScreen(), settings);
      case otp:
        return _fade(
          OtpScreen(phone: args['phone'] ?? ''),
          settings,
        );
      case privacy:
        return _slide(const PrivacyScreen(), settings);
      case home:
        return _fade(const MainNavigationContainer(), settings);
      case search:
        return _slide(const SearchScreen(), settings);
      case grocery:
        return _slide(const GroceryScreen(), settings);
      case restaurants:
        return _slide(const RestaurantsScreen(), settings);
      case restDetail:
        return _slide(
          RestaurantDetailScreen(restId: args['restId'] ?? ''),
          settings,
        );
      case product:
        return _slide(
          ProductDetailScreen(
            productId : args['productId'] ?? '',
            isGrocery : args['isGrocery'] ?? false,
          ),
          settings,
        );
      case wishlist:
        return _slide(const WishlistScreen(), settings);
      case cart:
        return _slide(const CartScreen(), settings);
      case addresses:
        return _slide(const AddressListScreen(), settings);
      case addrSelect:
        return _slide(const AddressSelectScreen(), settings);
      case addAddress:
        return _slide(const AddAddressScreen(), settings);
      case payment:
        return _slide(const PaymentScreen(), settings);
      case orderLoader:
        return _fade(const OrderLoaderScreen(), settings);
      case orderSuccess:
        return _fade(const OrderSuccessScreen(), settings);
      case tracking:
        return _slide(
          OrderTrackingScreen(
            orderId    : args['orderId']    ?? '',
            riderName  : args['riderName']  ?? '',
            riderPhone : args['riderPhone'] ?? '',
          ),
          settings,
        );
      case orders:
        return _slide(const OrdersScreen(), settings);
      case invoice:
        return _slide(
          InvoiceScreen(orderId: args['orderId'] ?? ''),
          settings,
        );
      case profile:
        return _slide(const ProfileScreen(), settings);
      case editProfile:
        return _slide(const EditProfileScreen(), settings);
      case wallet:
        return _slide(const WalletScreen(), settings);
      case offers:
        return _slide(const OffersScreen(), settings);
      case refer:
        return _slide(const ReferScreen(), settings);
      case notifications:
        return _slide(const NotificationsScreen(), settings);
      case rating:
        return _slide(const RatingScreen(), settings);
      case support:
        return _slide(const SupportScreen(), settings);
      default:
        return _fade(const SplashScreen(), settings);
    }
  }

  // Fade transition
  static PageRouteBuilder _fade(Widget child, RouteSettings s) {
    return PageRouteBuilder(
      settings: s,
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 220),
    );
  }

  // Slide up transition
  static PageRouteBuilder _slide(Widget child, RouteSettings s) {
    return PageRouteBuilder(
      settings: s,
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, anim, __, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut));
        return SlideTransition(position: anim.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 260),
    );
  }
}
