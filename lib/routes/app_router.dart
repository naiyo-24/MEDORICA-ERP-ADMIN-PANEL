import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/distributor/distributor_screen.dart';
import '../screens/help_center/help_center_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/portfolio/portfolio_screen.dart';
import '../screens/visual_ads/visual_ads_screen.dart';

class AppRoutePaths {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String distributor = '/distributor';
  static const String notifications = '/notifications';
  static const String visualAds = '/visual-ads';
  static const String portfolio = '/portfolio';
  static const String helpCenter = '/help-center';
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
      path: AppRoutePaths.distributor,
      name: 'distributor',
      builder: (context, state) => const DistributorScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.notifications,
      name: 'notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.visualAds,
      name: 'visual-ads',
      builder: (context, state) => const VisualAdsScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.portfolio,
      name: 'portfolio',
      builder: (context, state) => const PortfolioScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.helpCenter,
      name: 'help-center',
      builder: (context, state) => const HelpCenterScreen(),
    ),
  ],
);
