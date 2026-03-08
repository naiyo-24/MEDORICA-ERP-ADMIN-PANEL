enum AppointmentStatus { scheduled, completed, cancelled, rescheduled }

class MRAppointment {
  const MRAppointment({
    required this.id,
    required this.dateTime,
    required this.mrId,
    required this.mrName,
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
  final String mrId;
  final String mrName;
  final String doctorName;
  final String chamberName;
  final String chamberAddress;
  final String chamberPhone;
  final String doctorPhone;
  final String doctorSpecialization;
  final AppointmentStatus status;

  MRAppointment copyWith({
    String? id,
    DateTime? dateTime,
    String? mrId,
    String? mrName,
    String? doctorName,
    String? chamberName,
    String? chamberAddress,
    String? chamberPhone,
    String? doctorPhone,
    String? doctorSpecialization,
    AppointmentStatus? status,
  }) {
    return MRAppointment(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      mrId: mrId ?? this.mrId,
      mrName: mrName ?? this.mrName,
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
