enum MROrderStatus { pending, shipped, dispatched, delivered }

class MROrder {
  const MROrder({
    required this.id,
    required this.orderDate,
    required this.deliveryDateTime,
    required this.mrId,
    required this.mrName,
    required this.doctorName,
    required this.chemistShopName,
    required this.distributorName,
    required this.status,
    this.productsWithPrice,
    this.totalAmountRupees = 0,
  });

  final String id;
  final DateTime orderDate;
  final DateTime deliveryDateTime;
  final String mrId;
  final String mrName;
  final String doctorName;
  final String chemistShopName;
  final String distributorName;
  final MROrderStatus status;
  final dynamic productsWithPrice;
  final double totalAmountRupees;

  MROrder copyWith({
    String? id,
    DateTime? orderDate,
    DateTime? deliveryDateTime,
    String? mrId,
    String? mrName,
    String? doctorName,
    String? chemistShopName,
    String? distributorName,
    MROrderStatus? status,
    dynamic productsWithPrice,
    double? totalAmountRupees,
  }) {
    return MROrder(
      id: id ?? this.id,
      orderDate: orderDate ?? this.orderDate,
      deliveryDateTime: deliveryDateTime ?? this.deliveryDateTime,
      mrId: mrId ?? this.mrId,
      mrName: mrName ?? this.mrName,
      doctorName: doctorName ?? this.doctorName,
      chemistShopName: chemistShopName ?? this.chemistShopName,
      distributorName: distributorName ?? this.distributorName,
      status: status ?? this.status,
      productsWithPrice: productsWithPrice ?? this.productsWithPrice,
      totalAmountRupees: totalAmountRupees ?? this.totalAmountRupees,
    );
  }
}
