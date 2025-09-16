import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/enums/products_type.dart';
import 'package:leader_company/features/presentation/category/screens/category_screen.dart';
import 'package:leader_company/features/presentation/profile/screens/edit_profile_screen.dart';
import 'package:leader_company/features/presentation/profile/screens/profile_screen.dart';
import 'package:leader_company/features/presentation/wishlist/screens/wishlist_screen.dart';
import '../../../features/domain/category/entities/category.dart';
import '../../../features/domain/brand/entities/brand.dart';
import '../../../features/presentation/address/screens/address_list_screen.dart';
import '../../../features/presentation/all products/screens/all_category_products.dart';
import '../../../features/presentation/all products/screens/all_products_by_type_screen.dart';
import '../../../features/presentation/all products/screens/all_brand_products.dart';
import '../../../features/presentation/auth/screens/forgot_password_screen.dart';
import '../../../features/presentation/auth/screens/login_screen.dart';
import '../../../features/presentation/auth/screens/reset_password_screen.dart';
import '../../../features/presentation/auth/screens/signup_screen.dart';
import '../../../features/presentation/auth/screens/verification_screen.dart';
import '../../../features/presentation/cart/screens/cart_screen.dart';
import '../../../features/presentation/home/screens/home.dart';
import '../../../features/presentation/main layout/screens/main_layout_screen.dart';
import '../../../features/presentation/onboarding/screens/onboarding_screen.dart';
import '../../../features/presentation/order/screens/order_screen.dart';
import '../../../features/presentation/order/screens/orders_list_screen.dart';
import '../../../features/presentation/checkout/screens/checkout_screen.dart';
import '../../../features/presentation/product details/screens/product_screen.dart';
import '../../../features/presentation/splash/splash_screen.dart';
import '../../../features/presentation/search/screens/search_screen.dart';
import '../../../features/presentation/wallet/screens/wallet_screen.dart';
import 'package:page_transition/page_transition.dart';

class AppRoutes {

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgetPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verificationScreen = '/verification';
  static const String homeScreen = '/home';
  static const String categoryScreen = '/category';
  static const String wishListScreen = '/wishList';
  static const String profileScreen = '/profile';
  static const String editProfileScreen = '/editProfileScreen';
  static const String mainLayoutScreen = '/mainLayout';
  static const String cartScreen = '/cart';
  static const String productDetailScreen = '/product-details';
  static const String allCategoryProductsScreen = '/all-category-product';
  static const String allProductsByTypeScreen = '/allProductsByType';
  static const String allBrandProductsScreen = '/all-brand-products';
  static const String addressListScreen = '/addressListScreen';
  static const String checkoutScreen = '/checkout';
  static const String newCheckoutScreen = '/new-checkout';
  static const String successScreen = '/success';
  static const String allOrdersListScreen = '/all-orders-list';
  static const String orderDetailsScreen = '/order-details';
  static const String searchScreen = '/search-screen';
  static const String walletScreen = '/wallet-screen';

  static const PageTransitionType defaultTransition = PageTransitionType.sharedAxisHorizontal;

  static Route<dynamic> generateRoute(RouteSettings settings, {PageTransitionType? transitionType}) {
    Widget page;

    final transition = transitionType ?? defaultTransition;

    switch (settings.name) {
      case splash:
        page = const SplashScreen();
        break;
      case onboarding:
        page = const OnboardingScreen();
        break;
      case login:
        page = const LoginScreen();
        break;
      case signUp:
        page = const SignUpScreen();
        break;
      case forgetPassword:
        page = const ForgotPasswordScreen();
        break;
      case resetPassword:
        page = const ResetPasswordScreen();
        break;
      case verificationScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        page = VerificationScreen(
          contactInfo: args?['contactInfo'] as String? ?? '',
        );
        break;
      case homeScreen:
        page = const HomeScreen();
        break;
      case categoryScreen:
        page = const CategoryScreen();
        break;
      case wishListScreen:
        page = const WishlistScreen();
        break;
      case profileScreen:
        page = const ProfileScreen();
        break;
      case editProfileScreen:
        page = const EditProfileScreen();
        break;
      case mainLayoutScreen:
        page = const MainLayoutScreen();
        break;
      case cartScreen:
        page = const CartScreen();
        break;
      case productDetailScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        page = ProductDetailScreen(slug: args?['slug'] as String);
        break;
      case allCategoryProductsScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        page = AllCategoryProductsScreen(
          category: args?['category'] as Category,
        );
        break;
      case allBrandProductsScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        page = AllBrandProductsScreen(
          brand: args?['brand'] as Brand,
        );
        break;
      case AppRoutes.allProductsByTypeScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null ||
            args['productType'] == null ||
            args['title'] == null) {
          page = const Scaffold(
            body: Center(child: Text('Invalid product details type')),
          );
        } else {
          page = AllProductsByTypeScreen(
            productType: args['productType'] as ProductType,
            title: args['title'] as String,
            dealId: args['dealId'] as int?,
          );
        }
        break;
      case addressListScreen:
        page = const AddressListScreen();
        break;
      case newCheckoutScreen:
        page = const CheckoutScreen();
        break;
      case allOrdersListScreen:
        page = const OrdersListScreen();
        break;
      case AppRoutes.orderDetailsScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || args['orderId'] == null) {
          page = const Scaffold(body: Center(child: Text('Invalid order id')));
        } else {
          page = OrderDetailsScreen(orderId: args['orderId'] as int);
        }
        break;
      case searchScreen:
        page = const SearchScreen();
        break;
      case walletScreen:
        page = const WalletScreen();
        break;
      default:
        page = Scaffold(
          body: Center(child: Text('Route ${settings.name} not found')),
        );
    }

    return PageTransition(
      child: page,
      type: transition,
      settings: settings,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
  }

  static void navigateTo(
      BuildContext context,
      String route, {
        Object? arguments,
        PageTransitionType? transitionType,
      }) {
    Navigator.push(
      context,
      generateRoute(RouteSettings(name: route, arguments: arguments),
          transitionType: transitionType),
    );
  }

  static void navigateToAndReplace(
      BuildContext context,
      String route, {
        Object? arguments,
        PageTransitionType? transitionType,
      }) {
    Navigator.pushReplacement(
      context,
      generateRoute(RouteSettings(name: route, arguments: arguments),
          transitionType: transitionType),
    );
  }

  static void navigateToAndRemoveUntil(
      BuildContext context,
      String route, {
        PageTransitionType? transitionType,
      }) {
    Navigator.pushAndRemoveUntil(
      context,
      generateRoute(RouteSettings(name: route), transitionType: transitionType),
          (route) => false,
    );
  }
}