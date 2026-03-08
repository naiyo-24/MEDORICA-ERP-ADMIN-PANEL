enum ASMAppointmentStatus { scheduled, completed, cancelled, rescheduled }

class ASMAppointment {
  const ASMAppointment({
    required this.id,
    required this.dateTime,
    required this.asmId,
    required this.asmName,
    required this.doctorName,
    required this.chamberName,
    required this.chamberAddress,
    required this.chamberPhone,
    required this.doctorPhone,
    required this.doctorSpecialization,
    required this.status,
  });

  final String id;
  final DateTime dateTime;
  final String asmId;
  final String asmName;
  final String doctorName;
  final String chamberName;
  final String chamberAddress;
  final String chamberPhone;
  final String doctorPhone;
  final String doctorSpecialization;
  final ASMAppointmentStatus status;

  ASMAppointment copyWith({
    String? id,
    DateTime? dateTime,
    String? asmId,
    String? asmName,
    String? doctorName,
    String? chamberName,
    String? chamberAddress,
    String? chamberPhone,
    String? doctorPhone,
    String? doctorSpecialization,
    ASMAppointmentStatus? status,
  }) {
    return ASMAppointment(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      asmId: asmId ?? this.asmId,
      asmName: asmName ?? this.asmName,
      doctorName: doctorName ?? this.doctorName,
      chamberName: chamberName ?? this.chamberName,
      chamberAddress: chamberAddress ?? this.chamberAddress,
      chamberPhone: chamberPhone ?? this.chamberPhone,
      doctorPhone: doctorPhone ?? this.doctorPhone,
      doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
      status: status ?? this.status,
    );
  }
}
