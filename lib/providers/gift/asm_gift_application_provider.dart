import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/gift/asm_gift_application.dart';
import '../../notifiers/gift/asm_gift_application_notifier.dart';

final asmGiftApplicationNotifierProvider =
    NotifierProvider<ASMGiftApplicationNotifier, ASMGiftApplicationState>(
      ASMGiftApplicationNotifier.new,
    );

final asmGiftApplicationListProvider = Provider<List<ASMGiftApplication>>((
  ref,
) {
  return ref.watch(asmGiftApplicationNotifierProvider).filteredApplications;
});

final asmGiftApplicationCountProvider = Provider<int>((ref) {
  return ref.watch(asmGiftApplicationListProvider).length;
});

final asmGiftDoctorOptionsProvider = Provider<List<String>>((ref) {
  return ref.read(asmGiftApplicationNotifierProvider.notifier).doctorOptions;
});
