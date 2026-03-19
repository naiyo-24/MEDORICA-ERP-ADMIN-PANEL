enum ASMAppointmentStatus { scheduled, completed, cancelled, rescheduled }

class ASMAppointment {
  const ASMAppointment({
    required this.id,
    required this.dateTime,
    required this.asmId,
    this.place,
    this.doctor_id,
    this.visual_ads,
    required this.status,
    this.asmName = '',
    this.doctorName = '',
    this.chamberName = '',
    this.chamberAddress = '',
    this.chamberPhone = '',
    this.doctorPhone = '',
    this.doctorSpecialization = '',
    this.appointmentProofImage,
  });

  final String id;
  final DateTime dateTime;
  final String asmId;
  final String? place;
  final String? doctor_id;
  final List<dynamic>? visual_ads;
  final ASMAppointmentStatus status;
  final String asmName;
  final String doctorName;
  final String chamberName;
  final String chamberAddress;
  final String chamberPhone;
  final String doctorPhone;
  final String doctorSpecialization;
  final String? appointmentProofImage;

  ASMAppointment copyWith({
    String? id,
    DateTime? dateTime,
    String? asmId,
    String? place,
    String? doctor_id,
    List<dynamic>? visual_ads,
    String? asmName,
    String? doctorName,
    String? chamberName,
    String? chamberAddress,
    String? chamberPhone,
    String? doctorPhone,
    String? doctorSpecialization,
    ASMAppointmentStatus? status,
    String? appointmentProofImage,
  }) {
    return ASMAppointment(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      asmId: asmId ?? this.asmId,
      place: place ?? this.place,
      doctor_id: doctor_id ?? this.doctor_id,
      visual_ads: visual_ads ?? this.visual_ads,
      asmName: asmName ?? this.asmName,
      doctorName: doctorName ?? this.doctorName,
      chamberName: chamberName ?? this.chamberName,
      chamberAddress: chamberAddress ?? this.chamberAddress,
      chamberPhone: chamberPhone ?? this.chamberPhone,
      doctorPhone: doctorPhone ?? this.doctorPhone,
      doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
      status: status ?? this.status,
      appointmentProofImage:
          appointmentProofImage ?? this.appointmentProofImage,
    );
  }
}
