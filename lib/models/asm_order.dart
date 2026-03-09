enum ASMOrderStatus { pending, shipped, dispatched, delivered }

class ASMOrder {
  const ASMOrder({
    required this.id,
    required this.orderDate,
    required this.deliveryDateTime,
    required this.asmId,
    required this.asmName,
    required this.doctorName,
    required this.chemistShopName,
    required this.distributorName,
    required this.status,
  });

  final String id;
  final DateTime orderDate;
  final DateTime deliveryDateTime;
  final String asmId;
  final String asmName;
  final String doctorName;
  final String chemistShopName;
  final String distributorName;
  final ASMOrderStatus status;

  ASMOrder copyWith({
    String? id,
    DateTime? orderDate,
    DateTime? deliveryDateTime,
    String? asmId,
    String? asmName,
    String? doctorName,
    String? chemistShopName,
    String? distributorName,
    ASMOrderStatus? status,
  }) {
    return ASMOrder(
      id: id ?? this.id,
      orderDate: orderDate ?? this.orderDate,
      deliveryDateTime: deliveryDateTime ?? this.deliveryDateTime,
      asmId: asmId ?? this.asmId,
      asmName: asmName ?? this.asmName,
      doctorName: doctorName ?? this.doctorName,
      chemistShopName: chemistShopName ?? this.chemistShopName,
      distributorName: distributorName ?? this.distributorName,
      status: status ?? this.status,
    );
  }
}
