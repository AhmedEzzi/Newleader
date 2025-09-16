import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:leader_company/core/services/widget_service.dart';
import 'package:leader_company/core/utils/constants/app_strings.dart';
import 'package:leader_company/core/utils/helpers/ui_helper.dart';
import 'package:leader_company/features/presentation/brand/controller/brand_provider.dart';
import 'package:leader_company/features/presentation/home/controller/home_provider.dart';
import 'package:leader_company/features/presentation/search/controller/search_provider.dart';
import 'package:uuid/uuid.dart';
import 'core/config/app_config.dart/app_config.dart';
import 'core/config/routes.dart/routes.dart';
import 'core/config/themes.dart/theme.dart';
import 'core/di/injection_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/providers/localization/app_localizations.dart';
import 'core/providers/localization/language_provider.dart';
import 'core/utils/local_storage/local_storage_keys.dart';
import 'core/utils/local_storage/secure_storage.dart';
import 'core/utils/local_storage/shared_pref.dart';
import 'core/api/api_provider.dart';
import 'features/presentation/address/controller/address_provider.dart';
import 'features/presentation/auth/controller/auth_provider.dart';
import 'features/presentation/cart/controller/cart_provider.dart';
import 'features/presentation/category/controller/provider.dart';
import 'features/presentation/coupon/controller/coupon_provider.dart';
import 'features/presentation/main layout/controller/layout_provider.dart';
import 'features/presentation/order/controller/order_provider.dart';
import 'features/presentation/checkout/controller/payment_provider.dart';
import 'features/presentation/product details/controller/product_provider.dart';
import 'features/presentation/profile/controller/profile_provider.dart';
import 'features/presentation/review/controller/reviews_provider.dart';
import 'features/presentation/slider/controller/provider.dart';
import 'features/presentation/wishlist/controller/wishlist_provider.dart';
import 'features/presentation/wallet/controller/wallet_provider.dart';
import 'features/presentation/club_point/controller/club_point_provider.dart';
import 'firebase_options.dart';

// Global navigator key for deep link navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> getInitData() async {
  AppStrings.token = await SecureStorage().get<String>(
    LocalStorageKey.userToken,
  );
  AppStrings.userId = await SecureStorage().get<String>(LocalStorageKey.userId);
  AppStrings.userEmail = await SecureStorage().get<String>(
    LocalStorageKey.userEmail,
  );
  AppStrings.userName = await SecureStorage().get<String>(
    LocalStorageKey.userName,
  );
  AppStrings.tempUserId = await SecureStorage().get<String>(
    LocalStorageKey.tempUserId,
  );
}

Future<void> checkAndGenerateTempUserId() async {
  if (AppStrings.tempUserId == null) {
    AppStrings.tempUserId = const Uuid().v4();
    await SecureStorage().save(
      LocalStorageKey.tempUserId,
      AppStrings.tempUserId,
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for the entire app using our helper
  UIHelper.setTransparentStatusBar();

  await SharedPrefs.init();
  await setupDependencies();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize widget service
  await WidgetService().initialize();

  // Register widget interactivity
  await WidgetService().registerInteractivity();

  // Get saved locale from storage
  Locale locale = await sl<LanguageProvider>().getLocale();
  await getInitData();

  // Initialize API provider with the saved language
  sl<ApiProvider>().setLanguage(locale.languageCode);

  Future<String> getStartupScreen() async {
    await checkAndGenerateTempUserId();
    // Always return splash screen as the initial route
    return AppRoutes.splash;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => sl<HomeProvider>()),
        ChangeNotifierProvider(create: (_) => sl<LayoutProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ProductDetailsProvider>()),
        ChangeNotifierProvider(create: (_) => sl<LanguageProvider>()..setLocale(locale)),
        ChangeNotifierProvider(create: (_) => sl<CategoryProvider>()),
        ChangeNotifierProvider(create: (_) => sl<BrandProvider>()),
        ChangeNotifierProvider(create: (_) => sl<SliderProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ReviewProvider>()),
        ChangeNotifierProvider(create: (_) => sl<WishlistProvider>()),
        ChangeNotifierProvider(create: (_) => sl<CartProvider>()),
        ChangeNotifierProvider(create: (_) => sl<AddressProvider>()),
        ChangeNotifierProvider(create: (_) => sl<CouponProvider>()),
        ChangeNotifierProvider(create: (_) => sl<PaymentProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ProfileProvider>()),
        ChangeNotifierProvider(create: (_) => sl<OrderProvider>()),
        ChangeNotifierProvider(create: (_) => sl<SearchProvider>()),
        ChangeNotifierProvider(create: (_) => sl<WalletProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ClubPointProvider>()),
      ],
      child: MyApp(route: await getStartupScreen()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.route});

  final String route;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  late final DeepLinkHandler _dl = DeepLinkHandler();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _dl.init(); // بدون delay

    // Initialize deep linking after a delay to ensure everything is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        DeepLinkHandler().init();
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        debugPrint('Building MyApp with locale: ${languageProvider.locale.languageCode}');

        return UIHelper.wrapWithStatusBarConfig(
          MaterialApp(
            navigatorKey: navigatorKey,
            title: AppConfig().appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(languageProvider.locale.languageCode),
            themeMode: ThemeMode.light,
            locale: languageProvider.locale,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ar', 'EG'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              debugPrint('Resolving locale: ${locale?.languageCode}');

              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  debugPrint('Resolved to supported locale: ${supportedLocale.languageCode}');
                  return supportedLocale;
                }
              }
              debugPrint('No matching locale, using default: ${supportedLocales.first.languageCode}');
              return supportedLocales.first;
            },
            onGenerateRoute: AppRoutes.generateRoute,
            initialRoute: widget.route,
          ),
        );
      },
    );
  }
}


class DeepLinkHandler {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<void> init() async {
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) _handleUri(initialUri);

    _sub = _appLinks.uriLinkStream.listen(_handleUri, onError: (e) {
      debugPrint('Deeplink error: $e');
    });
  }

  void dispose() => _sub?.cancel();

  void _handleUri(Uri uri) {
    // App Links
    if (uri.scheme.startsWith('http')) {
      if (uri.host == 'admin.leadercompany-eg.com' &&
          uri.pathSegments.isNotEmpty &&
          uri.pathSegments.first == 'product') {
        final slug = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
        if (slug != null) {
          navigatorKey.currentState?.pushNamed(
            AppRoutes.productDetailScreen,
            arguments: slug,
          );
        }
      }
    }
    // Custom scheme: leadercompany://product/<slug>
    else if (uri.scheme == 'leadercompany' &&
        uri.host == 'product' &&
        uri.pathSegments.isNotEmpty) {
      final slug = uri.pathSegments.first;
      navigatorKey.currentState?.pushNamed(
        AppRoutes.productDetailScreen,
        arguments: slug,
      );
    }
  }
}


