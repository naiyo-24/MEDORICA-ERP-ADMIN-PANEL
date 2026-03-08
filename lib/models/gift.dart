class Gift {
  const Gift({
    required this.id,
    required this.itemName,
    required this.description,
    required this.quantityInInventory,
    required this.price,
    required this.createdAt,
  });

  final String id;
  final String itemName;
  final String description;
  final int quantityInInventory;
  final double price;
  final DateTime createdAt;

  Gift copyWith({
    String? id,
    String? itemName,
    String? description,
    int? quantityInInventory,
    double? price,
    DateTime? createdAt,
  }) {
    return Gift(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      description: description ?? this.description,
      quantityInInventory: quantityInInventory ?? this.quantityInInventory,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
