import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/visual_ads.dart';
import '../notifiers/visual_ads_notifier.dart';

final visualAdsNotifierProvider =
    NotifierProvider<VisualAdsNotifier, VisualAdsState>(VisualAdsNotifier.new);

final visualAdsListProvider = Provider<List<VisualAd>>((ref) {
  return ref.watch(visualAdsNotifierProvider).ads;
});
