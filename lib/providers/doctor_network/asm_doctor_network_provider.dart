import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/doctor_network/asm_doctor_network.dart';
import '../../notifiers/doctor_network/asm_doctor_network_notifier.dart';
import '../../services/doctor_network/asm/asm_doctor_network_services.dart';

final asmDoctorNetworkServicesProvider = Provider<ASMDoctorNetworkServices>((ref) {
  return ASMDoctorNetworkServices();
});

final asmDoctorNetworkNotifierProvider =
    NotifierProvider<ASMDoctorNetworkNotifier, ASMDoctorNetworkState>(
      ASMDoctorNetworkNotifier.new,
    );

final asmDoctorListProvider = Provider<List<ASMDoctorNetwork>>((ref) {
  final state = ref.watch(asmDoctorNetworkNotifierProvider);
  return state.filteredDoctorList;
});

final asmDoctorCountProvider = Provider<int>((ref) {
  final list = ref.watch(asmDoctorListProvider);
  return list.length;
});

final uniqueASMsProvider = Provider<List<String>>((ref) {
  final state = ref.watch(asmDoctorNetworkNotifierProvider);
  return state.uniqueASMs;
});

final uniqueASMDepartmentsProvider = Provider<List<String>>((ref) {
  final state = ref.watch(asmDoctorNetworkNotifierProvider);
  return state.uniqueDepartments;
});
