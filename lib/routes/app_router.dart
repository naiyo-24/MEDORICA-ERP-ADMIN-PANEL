import 'package:go_router/go_router.dart';

import '../screens/attendance/asm_attendance_screen.dart';
import '../screens/attendance/mr_attendance_screen.dart';
import '../screens/appointments/asm_appointments_screen.dart';
import '../screens/appointments/mr_appointments_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/distributor/distributor_screen.dart';
import '../screens/chemist_shop/asm_chemist_shop_screen.dart';
import '../screens/chemist_shop/mr_chemist_shop_screen.dart';
import '../screens/doctor_network/asm_doctor_network_screen.dart';
import '../screens/doctor_network/mr_doctor_network_screen.dart';
import '../screens/gift/asm_gift_applications_screen.dart';
import '../screens/gift/gift_screen.dart';
import '../screens/gift/mr_gift_applications_screen.dart';
import '../screens/help_center/help_center_screen.dart';
import '../screens/monthly_target/asm_monthly_target_screen.dart';
import '../screens/monthly_target/mr_monthly_target_screen.dart';
import '../screens/month_trip_plan/asm_month_trip_plan_screen.dart';
import '../screens/month_trip_plan/mr_month_trip_plan_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/onboarding/asm_screen.dart';
import '../screens/onboarding/mr_screen.dart';
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
  static const String mrOnboarding = '/mr-onboarding';
  static const String asmOnboarding = '/asm-onboarding';
  static const String mrDoctorNetwork = '/mr-doctor-network';
  static const String asmDoctorNetwork = '/asm-doctor-network';
  static const String mrAttendance = '/mr-attendance';
  static const String asmAttendance = '/asm-attendance';
  static const String mrAppointments = '/mr-appointments';
  static const String asmAppointments = '/asm-appointments';
  static const String mrChemistShop = '/mr-chemist-shop-network';
  static const String asmChemistShop = '/asm-chemist-shop-network';
  static const String giftManagement = '/gift-management';
  static const String mrGiftApplications = '/mr-gift-applications';
  static const String asmGiftApplications = '/asm-gift-applications';
  static const String mrMonthlyTarget = '/mr-monthly-target';
  static const String asmMonthlyTarget = '/asm-monthly-target';
  static const String mrMonthTripPlan = '/mr-month-trip-plan';
  static const String asmMonthTripPlan = '/asm-month-trip-plan';
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
    GoRoute(
      path: AppRoutePaths.mrOnboarding,
      name: 'mr-onboarding',
      builder: (context, state) => const MROnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.asmOnboarding,
      name: 'asm-onboarding',
      builder: (context, state) => const ASMOnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.mrDoctorNetwork,
      name: 'mr-doctor-network',
      builder: (context, state) => const MRDoctorNetworkScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.asmDoctorNetwork,
      name: 'asm-doctor-network',
      builder: (context, state) => const ASMDoctorNetworkScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.mrAttendance,
      name: 'mr-attendance',
      builder: (context, state) => const MRAttendanceScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.asmAttendance,
      name: 'asm-attendance',
      builder: (context, state) => const ASMAttendanceScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.mrAppointments,
      name: 'mr-appointments',
      builder: (context, state) => const MRAppointmentsScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.asmAppointments,
      name: 'asm-appointments',
      builder: (context, state) => const ASMAppointmentsScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.mrChemistShop,
      name: 'mr-chemist-shop-network',
      builder: (context, state) => const MRChemistShopScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.asmChemistShop,
      name: 'asm-chemist-shop-network',
      builder: (context, state) => const ASMChemistShopScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.giftManagement,
      name: 'gift-management',
      builder: (context, state) => const GiftScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.mrGiftApplications,
      name: 'mr-gift-applications',
      builder: (context, state) => const MRGiftApplicationsScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.asmGiftApplications,
      name: 'asm-gift-applications',
      builder: (context, state) => const ASMGiftApplicationsScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.mrMonthlyTarget,
      name: 'mr-monthly-target',
      builder: (context, state) => const MRMonthlyTargetScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.asmMonthlyTarget,
      name: 'asm-monthly-target',
      builder: (context, state) => const ASMMonthlyTargetScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.mrMonthTripPlan,
      name: 'mr-month-trip-plan',
      builder: (context, state) => const MRMonthTripPlanScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.asmMonthTripPlan,
      name: 'asm-month-trip-plan',
      builder: (context, state) => const ASMMonthTripPlanScreen(),
    ),
  ],
);
