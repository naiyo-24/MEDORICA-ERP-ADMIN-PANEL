import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/distributor.dart';
import '../notifiers/distributor_notifier.dart';

final distributorNotifierProvider =
    NotifierProvider<DistributorNotifier, DistributorState>(
      DistributorNotifier.new,
    );

final filteredDistributorsProvider = Provider<List<Distributor>>((ref) {
  final state = ref.watch(distributorNotifierProvider);
  final query = state.searchQuery.trim().toLowerCase();

  return state.distributors
      .where((item) {
        final matchesState = state.selectedState == 'All States'
            ? true
            : item.state == state.selectedState;

        if (!matchesState) {
          return false;
        }

        if (query.isEmpty) {
          return true;
        }

        return item.name.toLowerCase().contains(query) ||
            item.city.toLowerCase().contains(query) ||
            item.state.toLowerCase().contains(query);
      })
      .toList(growable: false);
});

final distributorStatesProvider = Provider<List<String>>((ref) {
  final distributors = ref.watch(distributorNotifierProvider).distributors;
  final states = distributors.map((item) => item.state).toSet().toList()
    ..sort();

  return ['All States', ...states];
});
