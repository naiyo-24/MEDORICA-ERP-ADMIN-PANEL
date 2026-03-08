import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr_gift_application.dart';
import '../notifiers/mr_gift_application_notifier.dart';

final mrGiftApplicationNotifierProvider =
    NotifierProvider<MRGiftApplicationNotifier, MRGiftApplicationState>(
      MRGiftApplicationNotifier.new,
    );

final mrGiftApplicationListProvider = Provider<List<MRGiftApplication>>((ref) {
  return ref.watch(mrGiftApplicationNotifierProvider).filteredApplications;
});

final mrGiftApplicationCountProvider = Provider<int>((ref) {
  return ref.watch(mrGiftApplicationListProvider).length;
});

final mrGiftDoctorOptionsProvider = Provider<List<String>>((ref) {
  return ref.read(mrGiftApplicationNotifierProvider.notifier).doctorOptions;
});
