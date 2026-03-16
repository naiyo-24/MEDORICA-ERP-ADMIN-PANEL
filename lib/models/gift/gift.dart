class Gift {
  const Gift({
    required this.giftId,
    required this.itemName,
    required this.description,
    required this.quantityInInventory,
    required this.price,
    required this.createdAt,
    this.updatedAt,
  });

  final int giftId;
  final String itemName;
  final String description;
  final int quantityInInventory;
  final double price;
  final DateTime createdAt;
  final DateTime? updatedAt;

  String get id => giftId.toString();

  Gift copyWith({
    int? giftId,
    String? itemName,
    String? description,
    int? quantityInInventory,
    double? price,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Gift(
      giftId: giftId ?? this.giftId,
      itemName: itemName ?? this.itemName,
      description: description ?? this.description,
      quantityInInventory: quantityInInventory ?? this.quantityInInventory,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      giftId: json['gift_id'] as int? ?? 0,
      itemName: json['product_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      quantityInInventory: json['quantity_in_stock'] as int? ?? 0,
      price: (json['price_in_rupees'] as num?)?.toDouble() ?? 0,
      createdAt: json['created_at'] == null
          ? DateTime.now()
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gift_id': giftId,
      'product_name': itemName,
      'description': description,
      'quantity_in_stock': quantityInInventory,
      'price_in_rupees': price,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
