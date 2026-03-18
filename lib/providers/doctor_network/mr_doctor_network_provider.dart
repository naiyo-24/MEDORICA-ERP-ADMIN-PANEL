import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/doctor_network/mr_doctor_network.dart';
import '../../notifiers/doctor_network/mr_doctor_network_notifier.dart';

import '../../services/doctor_network/mr/mr_doctor_network_services.dart';

final mrDoctorNetworkServicesProvider = Provider<MRDoctorNetworkServices>((
  ref,
) {
  return MRDoctorNetworkServices();
});

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

final mrDoctorNetworkIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(mrDoctorNetworkNotifierProvider).isLoading;
});
