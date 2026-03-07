class RegionMetric {
  const RegionMetric({required this.region, required this.count});

  final String region;
  final int count;
}

class MonthlyOrderMetric {
  const MonthlyOrderMetric({required this.month, required this.totalOrders});

  final int month;
  final int totalOrders;
}

class DashboardData {
  const DashboardData({
    required this.totalMr,
    required this.totalAsm,
    required this.totalDistributors,
    required this.totalChemistShops,
    required this.totalDoctors,
    required this.mrRegionCounts,
    required this.asmRegionCounts,
    required this.distributorRegionCounts,
    required this.orderTrendsByYear,
  });

  final int totalMr;
  final int totalAsm;
  final int totalDistributors;
  final int totalChemistShops;
  final int totalDoctors;

  final List<RegionMetric> mrRegionCounts;
  final List<RegionMetric> asmRegionCounts;
  final List<RegionMetric> distributorRegionCounts;
  final Map<int, List<MonthlyOrderMetric>> orderTrendsByYear;

  List<int> get availableYears {
    final years = orderTrendsByYear.keys.toList()..sort();
    return years;
  }
}
