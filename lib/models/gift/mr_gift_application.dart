enum GiftApplicationStatus { pending, shipped, delivered }

class MRGiftApplication {
  const MRGiftApplication({
    required this.id,
    required this.doctorName,
    required this.giftId,
    required this.giftItemRequired,
    required this.mrRequestedById,
    required this.mrRequestedBy,
    required this.date,
    required this.occasion,
    required this.message,
    required this.status,
  });

  final String id;
  final String doctorName;
  final String giftId;
  final String giftItemRequired;
  final String mrRequestedById;
  final String mrRequestedBy;
  final DateTime date;
  final String occasion;
  final String message;
  final GiftApplicationStatus status;

  MRGiftApplication copyWith({
    String? id,
    String? doctorName,
    String? giftId,
    String? giftItemRequired,
    String? mrRequestedById,
    String? mrRequestedBy,
    DateTime? date,
    String? occasion,
    String? message,
    GiftApplicationStatus? status,
  }) {
    return MRGiftApplication(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      giftId: giftId ?? this.giftId,
      giftItemRequired: giftItemRequired ?? this.giftItemRequired,
      mrRequestedById: mrRequestedById ?? this.mrRequestedById,
      mrRequestedBy: mrRequestedBy ?? this.mrRequestedBy,
      date: date ?? this.date,
      occasion: occasion ?? this.occasion,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
