import 'dart:typed_data';

class VisualAd {
  const VisualAd({
    this.id,
    required this.adId,
    required this.name,
    this.imageUrl,
    this.imageBytes,
    this.imageFileName,
    required this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String adId;
  final String name;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final String? imageFileName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  VisualAd copyWith({
    int? id,
    String? adId,
    String? name,
    String? imageUrl,
    Uint8List? imageBytes,
    String? imageFileName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearImage = false,
  }) {
    return VisualAd(
      id: id ?? this.id,
      adId: adId ?? this.adId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      imageBytes: clearImage ? null : imageBytes ?? this.imageBytes,
      imageFileName: clearImage ? null : imageFileName ?? this.imageFileName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory VisualAd.fromJson(Map<String, dynamic> json) {
    return VisualAd(
      id: json['id'] as int?,
      adId: json['ad_id'] as String? ?? '',
      name: json['medicine_name'] as String? ?? '',
      imageUrl: json['ad_image'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad_id': adId,
      'medicine_name': name,
      'ad_image': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
