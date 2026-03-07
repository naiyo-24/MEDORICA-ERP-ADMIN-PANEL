import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/visual_ads/visual_ads_screen.dart';

class AppRoutePaths {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String visualAds = '/visual-ads';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutePaths.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutePaths.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.dashboard,
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.visualAds,
      name: 'visual-ads',
      builder: (context, state) => const VisualAdsScreen(),
    ),
  ],
);
