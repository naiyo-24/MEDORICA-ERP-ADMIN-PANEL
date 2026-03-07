import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard.dart';
import '../notifiers/dashboard_notifier.dart';

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);

final dashboardDataProvider = Provider<DashboardData>((ref) {
  return ref.watch(dashboardNotifierProvider).data;
});

final selectedOrderYearProvider = Provider<int>((ref) {
  return ref.watch(dashboardNotifierProvider).selectedYear;
});
