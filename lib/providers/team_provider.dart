import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/team.dart';
import '../notifiers/team_notifier.dart';
import '../services/team/team_services.dart';

final teamServicesProvider = Provider<TeamServices>((ref) {
  return TeamServices();
});

final teamNotifierProvider = NotifierProvider<TeamNotifier, TeamState>(
  TeamNotifier.new,
);

final teamListProvider = Provider<List<Team>>((ref) {
  return ref.watch(teamNotifierProvider).teams;
});

final teamCountProvider = Provider<int>((ref) {
  return ref.watch(teamListProvider).length;
});

final teamLoadingProvider = Provider<bool>((ref) {
  return ref.watch(teamNotifierProvider).isLoading;
});

final teamSavingProvider = Provider<bool>((ref) {
  return ref.watch(teamNotifierProvider).isSaving;
});

final teamErrorProvider = Provider<String?>((ref) {
  return ref.watch(teamNotifierProvider).error;
});
