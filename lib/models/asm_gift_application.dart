enum ASMGiftApplicationStatus { pending, shipped, delivered }

class ASMGiftApplication {
  const ASMGiftApplication({
    required this.id,
    required this.doctorName,
    required this.giftId,
    required this.giftItemRequired,
    required this.asmRequestedById,
    required this.asmRequestedBy,
    required this.date,
    required this.occasion,
    required this.message,
    required this.status,
  });

  final String id;
  final String doctorName;
  final String giftId;
  final String giftItemRequired;
  final String asmRequestedById;
  final String asmRequestedBy;
  final DateTime date;
  final String occasion;
  final String message;
  final ASMGiftApplicationStatus status;

  ASMGiftApplication copyWith({
    String? id,
    String? doctorName,
    String? giftId,
    String? giftItemRequired,
    String? asmRequestedById,
    String? asmRequestedBy,
    DateTime? date,
    String? occasion,
    String? message,
    ASMGiftApplicationStatus? status,
  }) {
    return ASMGiftApplication(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      giftId: giftId ?? this.giftId,
      giftItemRequired: giftItemRequired ?? this.giftItemRequired,
      asmRequestedById: asmRequestedById ?? this.asmRequestedById,
      asmRequestedBy: asmRequestedBy ?? this.asmRequestedBy,
      date: date ?? this.date,
      occasion: occasion ?? this.occasion,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
