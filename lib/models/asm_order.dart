enum ASMOrderStatus { pending, approved, shipped, delivered }

ASMOrderStatus parseASMOrderStatus(String? value) {
  switch (value?.toLowerCase().trim()) {
    case 'pending':
      return ASMOrderStatus.pending;
    case 'approved':
      return ASMOrderStatus.approved;
    case 'shipped':
      return ASMOrderStatus.shipped;
    case 'delivered':
      return ASMOrderStatus.delivered;
    default:
      return ASMOrderStatus.pending;
  }
}

double _parseAmount(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? 0;
  }
  return 0;
}

class ASMOrder {
  const ASMOrder({
    this.dbId,
    required this.id,
    required this.orderDate,
    required this.deliveryDateTime,
    required this.asmId,
    required this.asmName,
    this.distributorId,
    this.chemistShopId,
    this.doctorId,
    required this.doctorName,
    required this.chemistShopName,
    required this.distributorName,
    this.productsWithPrice,
    this.totalAmountRupees = 0,
    this.createdAt,
    this.updatedAt,
    required this.status,
  });

  final int? dbId;
  final String id;
  final DateTime orderDate;
  final DateTime deliveryDateTime;
  final String asmId;
  final String asmName;
  final String? distributorId;
  final String? chemistShopId;
  final String? doctorId;
  final String doctorName;
  final String chemistShopName;
  final String distributorName;
  final dynamic productsWithPrice;
  final double totalAmountRupees;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ASMOrderStatus status;

  factory ASMOrder.fromJson(Map<String, dynamic> json, {String? asmName}) {
    final createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'].toString())
        : null;
    final updatedAt = json['updated_at'] != null
        ? DateTime.tryParse(json['updated_at'].toString())
        : null;

    final doctorId = json['doctor_id']?.toString();
    final chemistShopId = json['chemist_shop_id']?.toString();
    final distributorId = json['distributor_id']?.toString();

    return ASMOrder(
      dbId: json['id'] as int?,
      id: json['order_id']?.toString() ?? '',
      orderDate: createdAt ?? DateTime.now(),
      deliveryDateTime: updatedAt ?? createdAt ?? DateTime.now(),
      asmId: json['asm_id']?.toString() ?? '',
      asmName: asmName ?? (json['asm_id']?.toString() ?? '-'),
      distributorId: distributorId,
      chemistShopId: chemistShopId,
      doctorId: doctorId,
      doctorName: doctorId ?? '-',
      chemistShopName: chemistShopId ?? '-',
      distributorName: distributorId ?? '-',
      productsWithPrice: json['products_with_price'],
      totalAmountRupees: _parseAmount(json['total_amount_rupees']),
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: parseASMOrderStatus(json['status']?.toString()),
    );
  }

  ASMOrder copyWith({
    int? dbId,
    String? id,
    DateTime? orderDate,
    DateTime? deliveryDateTime,
    String? asmId,
    String? asmName,
    String? distributorId,
    String? chemistShopId,
    String? doctorId,
    String? doctorName,
    String? chemistShopName,
    String? distributorName,
    dynamic productsWithPrice,
    double? totalAmountRupees,
    DateTime? createdAt,
    DateTime? updatedAt,
    ASMOrderStatus? status,
  }) {
    return ASMOrder(
      dbId: dbId ?? this.dbId,
      id: id ?? this.id,
      orderDate: orderDate ?? this.orderDate,
      deliveryDateTime: deliveryDateTime ?? this.deliveryDateTime,
      asmId: asmId ?? this.asmId,
      asmName: asmName ?? this.asmName,
      distributorId: distributorId ?? this.distributorId,
      chemistShopId: chemistShopId ?? this.chemistShopId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      chemistShopName: chemistShopName ?? this.chemistShopName,
      distributorName: distributorName ?? this.distributorName,
      productsWithPrice: productsWithPrice ?? this.productsWithPrice,
      totalAmountRupees: totalAmountRupees ?? this.totalAmountRupees,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }
}
