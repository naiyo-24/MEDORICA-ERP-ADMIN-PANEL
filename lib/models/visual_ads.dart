import 'dart:typed_data';

class VisualAd {
  const VisualAd({
    required this.id,
    required this.name,
    this.imageBytes,
    this.imageFileName,
    required this.createdAt,
  });

  final String id;
  final String name;
  final Uint8List? imageBytes;
  final String? imageFileName;
  final DateTime createdAt;

  VisualAd copyWith({
    String? id,
    String? name,
    Uint8List? imageBytes,
    String? imageFileName,
    DateTime? createdAt,
    bool clearImage = false,
  }) {
    return VisualAd(
      id: id ?? this.id,
      name: name ?? this.name,
      imageBytes: clearImage ? null : imageBytes ?? this.imageBytes,
      imageFileName: clearImage ? null : imageFileName ?? this.imageFileName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
