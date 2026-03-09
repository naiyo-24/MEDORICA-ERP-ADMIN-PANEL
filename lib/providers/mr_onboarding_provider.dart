import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr.dart';
import '../notifiers/mr_onboarding_notifier.dart';
import '../services/onboarding/mr_onboarding_services.dart';

final mrOnboardingServicesProvider = Provider<MROnboardingServices>((ref) {
  return MROnboardingServices();
});

final mrOnboardingNotifierProvider =
    NotifierProvider<MROnboardingNotifier, MROnboardingState>(
      MROnboardingNotifier.new,
    );

final mrListProvider = Provider<List<MR>>((ref) {
  return ref.watch(mrOnboardingNotifierProvider).filteredMRList;
});

final mrCountProvider = Provider<int>((ref) {
  return ref.watch(mrOnboardingNotifierProvider).mrList.length;
});
