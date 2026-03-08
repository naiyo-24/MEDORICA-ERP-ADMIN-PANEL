import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr_doctor_network.dart';
import '../notifiers/mr_doctor_network_notifier.dart';

final mrDoctorNetworkNotifierProvider =
    NotifierProvider<MRDoctorNetworkNotifier, MRDoctorNetworkState>(
      () => MRDoctorNetworkNotifier(),
    );

final mrDoctorListProvider = Provider<List<MRDoctorNetwork>>((ref) {
  final state = ref.watch(mrDoctorNetworkNotifierProvider);
  return state.filteredDoctorList;
});

final mrDoctorCountProvider = Provider<int>((ref) {
  final list = ref.watch(mrDoctorListProvider);
  return list.length;
});

final uniqueMRsProvider = Provider<List<String>>((ref) {
  final state = ref.watch(mrDoctorNetworkNotifierProvider);
  return state.uniqueMRs;
});

final uniqueDepartmentsProvider = Provider<List<String>>((ref) {
  final state = ref.watch(mrDoctorNetworkNotifierProvider);
  return state.uniqueDepartments;
});
