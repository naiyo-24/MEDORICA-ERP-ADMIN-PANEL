import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard.dart';

class DashboardState {
  const DashboardState({
    required this.data,
    required this.selectedYear,
    this.isLoading = false,
  });

  final DashboardData data;
  final int selectedYear;
  final bool isLoading;

  List<MonthlyOrderMetric> get selectedYearOrders {
    return data.orderTrendsByYear[selectedYear] ?? const [];
  }

  DashboardState copyWith({
    DashboardData? data,
    int? selectedYear,
    bool? isLoading,
  }) {
    return DashboardState(
      data: data ?? this.data,
      selectedYear: selectedYear ?? this.selectedYear,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    final data = _mockData();
    final defaultYear = data.availableYears.isNotEmpty
        ? data.availableYears.last
        : DateTime.now().year;

    return DashboardState(data: data, selectedYear: defaultYear);
  }

  void setOrderYear(int year) {
    if (!state.data.availableYears.contains(year)) {
      return;
    }
    state = state.copyWith(selectedYear: year);
  }

  DashboardData _mockData() {
    return const DashboardData(
      totalMr: 264,
      totalAsm: 54,
      totalDistributors: 79,
      totalChemistShops: 1360,
      totalDoctors: 940,
      mrRegionCounts: [
        RegionMetric(region: 'North', count: 62),
        RegionMetric(region: 'South', count: 54),
        RegionMetric(region: 'East', count: 47),
        RegionMetric(region: 'West', count: 58),
        RegionMetric(region: 'Central', count: 43),
      ],
      asmRegionCounts: [
        RegionMetric(region: 'North', count: 12),
        RegionMetric(region: 'South', count: 10),
        RegionMetric(region: 'East', count: 9),
        RegionMetric(region: 'West', count: 13),
        RegionMetric(region: 'Central', count: 10),
      ],
      distributorRegionCounts: [
        RegionMetric(region: 'North', count: 18),
        RegionMetric(region: 'South', count: 15),
        RegionMetric(region: 'East', count: 13),
        RegionMetric(region: 'West', count: 17),
        RegionMetric(region: 'Central', count: 16),
      ],
      orderTrendsByYear: {
        2024: [
          MonthlyOrderMetric(month: 1, totalOrders: 420),
          MonthlyOrderMetric(month: 2, totalOrders: 460),
          MonthlyOrderMetric(month: 3, totalOrders: 455),
          MonthlyOrderMetric(month: 4, totalOrders: 510),
          MonthlyOrderMetric(month: 5, totalOrders: 540),
          MonthlyOrderMetric(month: 6, totalOrders: 525),
          MonthlyOrderMetric(month: 7, totalOrders: 570),
          MonthlyOrderMetric(month: 8, totalOrders: 585),
          MonthlyOrderMetric(month: 9, totalOrders: 560),
          MonthlyOrderMetric(month: 10, totalOrders: 595),
          MonthlyOrderMetric(month: 11, totalOrders: 620),
          MonthlyOrderMetric(month: 12, totalOrders: 640),
        ],
        2025: [
          MonthlyOrderMetric(month: 1, totalOrders: 470),
          MonthlyOrderMetric(month: 2, totalOrders: 495),
          MonthlyOrderMetric(month: 3, totalOrders: 530),
          MonthlyOrderMetric(month: 4, totalOrders: 520),
          MonthlyOrderMetric(month: 5, totalOrders: 565),
          MonthlyOrderMetric(month: 6, totalOrders: 595),
          MonthlyOrderMetric(month: 7, totalOrders: 615),
          MonthlyOrderMetric(month: 8, totalOrders: 605),
          MonthlyOrderMetric(month: 9, totalOrders: 650),
          MonthlyOrderMetric(month: 10, totalOrders: 670),
          MonthlyOrderMetric(month: 11, totalOrders: 685),
          MonthlyOrderMetric(month: 12, totalOrders: 710),
        ],
      },
    );
  }
}
