class MRChemistShop {
  const MRChemistShop({
    required this.id,
    required this.shopPhoto,
    required this.shopName,
    required this.shopPhone,
    required this.shopEmail,
    required this.location,
    required this.description,
    required this.doctorName,
    required this.doctorPhone,
    required this.mrAddedBy,
    required this.mrAddedById,
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
  final String mrAddedBy;
  final String mrAddedById;
  final DateTime createdAt;
  final String? bankPassbookPhoto;

  MRChemistShop copyWith({
    String? id,
    String? shopPhoto,
    String? shopName,
    String? shopPhone,
    String? shopEmail,
    String? location,
    String? description,
    String? doctorName,
    String? doctorPhone,
    String? mrAddedBy,
    String? mrAddedById,
    DateTime? createdAt,
    String? bankPassbookPhoto,
  }) {
    return MRChemistShop(
      id: id ?? this.id,
      shopPhoto: shopPhoto ?? this.shopPhoto,
      shopName: shopName ?? this.shopName,
      shopPhone: shopPhone ?? this.shopPhone,
      shopEmail: shopEmail ?? this.shopEmail,
      location: location ?? this.location,
      description: description ?? this.description,
      doctorName: doctorName ?? this.doctorName,
      doctorPhone: doctorPhone ?? this.doctorPhone,
      mrAddedBy: mrAddedBy ?? this.mrAddedBy,
      mrAddedById: mrAddedById ?? this.mrAddedById,
      createdAt: createdAt ?? this.createdAt,
      bankPassbookPhoto: bankPassbookPhoto ?? this.bankPassbookPhoto,
    );
  }
}
