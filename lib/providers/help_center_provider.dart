import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/help_center.dart';
import '../notifiers/help_center_notifier.dart';

final helpCenterNotifierProvider =
    NotifierProvider<HelpCenterNotifier, HelpCenterState>(
        HelpCenterNotifier.new);

final helpCenterDataProvider = Provider<HelpCenterData>((ref) {
  return ref.watch(helpCenterNotifierProvider).data;
});
