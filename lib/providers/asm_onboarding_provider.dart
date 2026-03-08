import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asm.dart';
import '../notifiers/asm_onboarding_notifier.dart';

final asmOnboardingNotifierProvider =
    NotifierProvider<ASMOnboardingNotifier, ASMOnboardingState>(
      ASMOnboardingNotifier.new,
    );

final asmListProvider = Provider<List<ASM>>((ref) {
  return ref.watch(asmOnboardingNotifierProvider).filteredASMList;
});

final asmCountProvider = Provider<int>((ref) {
  return ref.watch(asmOnboardingNotifierProvider).asmList.length;
});
