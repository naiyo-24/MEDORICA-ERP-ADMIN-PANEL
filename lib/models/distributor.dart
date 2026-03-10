import 'dart:typed_data';

class Distributor {
  const Distributor({
    required this.id,
    required this.distId,
    required this.distName,
    this.distLocation,
    required this.distPhoneNo,
    this.distEmail,
    this.distDescription,
    this.distPhoto,
    this.distMinOrderValueRupees,
    this.distProducts,
    this.distExpectedDeliveryTimeDays,
    this.paymentTerms,
    this.bankName,
    this.bankAcNo,
    this.branchName,
    this.ifscCode,
    this.deliveryTerritories,
    required this.createdAt,
    required this.updatedAt,
    this.imageBytes,
    this.imageFileName,
  });

  final int id;
  final String distId;
  final String distName;
  final String? distLocation;
  final String distPhoneNo;
  final String? distEmail;
  final String? distDescription;
  final String? distPhoto;
  final double? distMinOrderValueRupees;
  final dynamic distProducts;
  final int? distExpectedDeliveryTimeDays;
  final String? paymentTerms;
  final String? bankName;
  final String? bankAcNo;
  final String? branchName;
  final String? ifscCode;
  final dynamic deliveryTerritories;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Uint8List? imageBytes;
  final String? imageFileName;

  String get locationLabel => distLocation ?? 'N/A';

  String get mapsQuery => '$distName, $distLocation';

  Distributor copyWith({
    int? id,
    String? distId,
    String? distName,
    String? distLocation,
    String? distPhoneNo,
    String? distEmail,
    String? distDescription,
    String? distPhoto,
    double? distMinOrderValueRupees,
    dynamic distProducts,
    int? distExpectedDeliveryTimeDays,
    String? paymentTerms,
    String? bankName,
    String? bankAcNo,
    String? branchName,
    String? ifscCode,
    dynamic deliveryTerritories,
    DateTime? createdAt,
    DateTime? updatedAt,
    Uint8List? imageBytes,
    String? imageFileName,
    bool clearImage = false,
  }) {
    return Distributor(
      id: id ?? this.id,
      distId: distId ?? this.distId,
      distName: distName ?? this.distName,
      distLocation: distLocation ?? this.distLocation,
      distPhoneNo: distPhoneNo ?? this.distPhoneNo,
      distEmail: distEmail ?? this.distEmail,
      distDescription: distDescription ?? this.distDescription,
      distPhoto: distPhoto ?? this.distPhoto,
      distMinOrderValueRupees:
          distMinOrderValueRupees ?? this.distMinOrderValueRupees,
      distProducts: distProducts ?? this.distProducts,
      distExpectedDeliveryTimeDays:
          distExpectedDeliveryTimeDays ?? this.distExpectedDeliveryTimeDays,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      bankName: bankName ?? this.bankName,
      bankAcNo: bankAcNo ?? this.bankAcNo,
      branchName: branchName ?? this.branchName,
      ifscCode: ifscCode ?? this.ifscCode,
      deliveryTerritories: deliveryTerritories ?? this.deliveryTerritories,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageBytes: clearImage ? null : imageBytes ?? this.imageBytes,
      imageFileName: clearImage ? null : imageFileName ?? this.imageFileName,
    );
  }

  factory Distributor.fromJson(Map<String, dynamic> json) {
    return Distributor(
      id: json['id'] as int,
      distId: json['dist_id'] as String,
      distName: json['dist_name'] as String,
      distLocation: json['dist_location'] as String?,
      distPhoneNo: json['dist_phone_no'] as String,
      distEmail: json['dist_email'] as String?,
      distDescription: json['dist_description'] as String?,
      distPhoto: json['dist_photo'] as String?,
      distMinOrderValueRupees:
          json['dist_min_order_value_rupees'] as double?,
      distProducts: json['dist_products'],
      distExpectedDeliveryTimeDays:
          json['dist_expected_delivery_time_days'] as int?,
      paymentTerms: json['payment_terms'] as String?,
      bankName: json['bank_name'] as String?,
      bankAcNo: json['bank_ac_no'] as String?,
      branchName: json['branch_name'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      deliveryTerritories: json['delivery_territories'],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'dist_id': distId,
        'dist_name': distName,
        'dist_location': distLocation,
        'dist_phone_no': distPhoneNo,
        'dist_email': distEmail,
        'dist_description': distDescription,
        'dist_photo': distPhoto,
        'dist_min_order_value_rupees': distMinOrderValueRupees,
        'dist_products': distProducts,
        'dist_expected_delivery_time_days': distExpectedDeliveryTimeDays,
        'payment_terms': paymentTerms,
        'bank_name': bankName,
        'bank_ac_no': bankAcNo,
        'branch_name': branchName,
        'ifsc_code': ifscCode,
        'delivery_territories': deliveryTerritories,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

