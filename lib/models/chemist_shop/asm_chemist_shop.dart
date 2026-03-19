class ASMChemistShop {
  const ASMChemistShop({
    required this.id,
    required this.shopPhoto,
    required this.shopName,
    required this.shopPhone,
    required this.shopEmail,
    required this.location,
    required this.description,
    required this.doctorName,
    required this.doctorPhone,
    required this.asmAddedBy,
    required this.asmAddedById,
    required this.createdAt,
    this.bankPassbookPhoto,
  });

  final String id;
  final String shopPhoto;
  final String shopName;
  final String shopPhone;
  final String shopEmail;
  final String location;
  final String description;
  final String doctorName;
  final String doctorPhone;
  final String asmAddedBy;
  final String asmAddedById;
  final DateTime createdAt;
  final String? bankPassbookPhoto;

  ASMChemistShop copyWith({
    String? id,
    String? shopPhoto,
    String? shopName,
    String? shopPhone,
    String? shopEmail,
    String? location,
    String? description,
    String? doctorName,
    String? doctorPhone,
    String? asmAddedBy,
    String? asmAddedById,
    DateTime? createdAt,
    String? bankPassbookPhoto,
  }) {
    return ASMChemistShop(
      id: id ?? this.id,
      shopPhoto: shopPhoto ?? this.shopPhoto,
      shopName: shopName ?? this.shopName,
      shopPhone: shopPhone ?? this.shopPhone,
      shopEmail: shopEmail ?? this.shopEmail,
      location: location ?? this.location,
      description: description ?? this.description,
      doctorName: doctorName ?? this.doctorName,
      doctorPhone: doctorPhone ?? this.doctorPhone,
      asmAddedBy: asmAddedBy ?? this.asmAddedBy,
      asmAddedById: asmAddedById ?? this.asmAddedById,
      createdAt: createdAt ?? this.createdAt,
      bankPassbookPhoto: bankPassbookPhoto ?? this.bankPassbookPhoto,
    );
  }
}
