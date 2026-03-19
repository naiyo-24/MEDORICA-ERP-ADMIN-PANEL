enum AppointmentStatus { scheduled, completed, cancelled, rescheduled }

class MRAppointment {
  const MRAppointment({
    required this.id,
    required this.dateTime,
    required this.mrId,
    required this.doctorId,
    required this.status,
    this.place,
    this.appointmentProofImage,
    this.visualAdsRaw,
  });

  final String id;
  final DateTime dateTime;
  final String mrId;
  final String doctorId;
  final AppointmentStatus status;
  final String? place;
  final String? appointmentProofImage;
  final List<dynamic>? visualAdsRaw;

  MRAppointment copyWith({
    String? id,
    DateTime? dateTime,
    String? mrId,
    String? doctorId,
    AppointmentStatus? status,
    String? place,
    String? appointmentProofImage,
    List<dynamic>? visualAdsRaw,
  }) {
    return MRAppointment(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      mrId: mrId ?? this.mrId,
      doctorId: doctorId ?? this.doctorId,
      status: status ?? this.status,
      place: place ?? this.place,
      appointmentProofImage: appointmentProofImage ?? this.appointmentProofImage,
      visualAdsRaw: visualAdsRaw ?? this.visualAdsRaw,
    );
  }
}
