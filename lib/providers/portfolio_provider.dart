import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/portfolio.dart';
import '../notifiers/portfolio_notifier.dart';

final portfolioNotifierProvider =
    NotifierProvider<PortfolioNotifier, PortfolioState>(PortfolioNotifier.new);

final portfolioDataProvider = Provider<PortfolioData>((ref) {
  return ref.watch(portfolioNotifierProvider).data;
});
