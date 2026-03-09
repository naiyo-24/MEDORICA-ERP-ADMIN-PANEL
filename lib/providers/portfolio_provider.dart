import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/portfolio.dart';
import '../notifiers/portfolio_notifier.dart';
import '../services/portfolio/portfolio_services.dart';

final portfolioServicesProvider = Provider<PortfolioServices>((ref) {
  return PortfolioServices();
});

final portfolioNotifierProvider =
    NotifierProvider<PortfolioNotifier, PortfolioState>(PortfolioNotifier.new);

final portfolioDataProvider = Provider<PortfolioData>((ref) {
  return ref.watch(portfolioNotifierProvider).data;
});
