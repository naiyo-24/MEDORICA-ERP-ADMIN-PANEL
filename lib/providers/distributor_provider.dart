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
            : (item.distLocation?.toLowerCase().contains(
                    state.selectedState.toLowerCase()) ??
                false);

        if (!matchesState) {
          return false;
        }

        if (query.isEmpty) {
          return true;
        }

        return item.distName.toLowerCase().contains(query) ||
            (item.distLocation?.toLowerCase().contains(query) ?? false);
      })
      .toList(growable: false);
});

final distributorStatesProvider = Provider<List<String>>((ref) {
  final distributors =
      ref.watch(distributorNotifierProvider).distributors;
  final states = <String>{};

  for (final distributor in distributors) {
    if (distributor.distLocation != null) {
      states.add(distributor.distLocation!);
    }
  }

  final stateList = states.toList()..sort();
  return ['All States', ...stateList];
});

final distributorIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(distributorNotifierProvider).isLoading;
});

final distributorErrorProvider = Provider<String?>((ref) {
  return ref.watch(distributorNotifierProvider).error;
});

final distributorRefreshProvider = FutureProvider<void>((ref) async {
  final notifier = ref.read(distributorNotifierProvider.notifier);
  await notifier.refreshDistributors();
});
