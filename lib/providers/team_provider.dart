import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/team.dart';
import '../notifiers/team_notifier.dart';

final teamNotifierProvider = NotifierProvider<TeamNotifier, TeamState>(
  TeamNotifier.new,
);

final teamListProvider = Provider<List<Team>>((ref) {
  return ref.watch(teamNotifierProvider).teams;
});

final teamCountProvider = Provider<int>((ref) {
  return ref.watch(teamListProvider).length;
});
