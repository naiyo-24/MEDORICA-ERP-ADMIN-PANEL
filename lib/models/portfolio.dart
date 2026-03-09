class PortfolioData {
  const PortfolioData.empty()
    : id = null,
      description = '',
      directorMessage = '',
      phone = '',
      email = '',
      website = '',
      address = '',
      officeAddress = '',
      instagram = '',
      facebook = '',
      linkedin = '',
      youtube = '',
      createdAt = null,
      updatedAt = null;

  const PortfolioData({
    this.id,
    required this.description,
    required this.directorMessage,
    required this.phone,
    required this.email,
    required this.website,
    this.address = '',
    this.officeAddress = '',
    required this.instagram,
    required this.facebook,
    required this.linkedin,
    this.youtube = '',
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String description;
  final String directorMessage;

  final String phone;
  final String email;
  final String website;
  final String address;
  final String officeAddress;
  final String instagram;
  final String facebook;
  final String linkedin;
  final String youtube;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return PortfolioData(
      id: json['id'] as int?,
      description: (json['company_about'] as String?) ?? '',
      directorMessage: (json['director_message'] as String?) ?? '',
      phone: (json['phn_no'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      website: (json['website'] as String?) ?? '',
      address: (json['address'] as String?) ?? '',
      officeAddress: (json['office_address'] as String?) ?? '',
      instagram: (json['instagram_link'] as String?) ?? '',
      facebook: (json['facebook_link'] as String?) ?? '',
      linkedin: (json['linkedin_link'] as String?) ?? '',
      youtube: (json['youtube_link'] as String?) ?? '',
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toApiMap() {
    return {
      'company_about': description,
      'director_message': directorMessage,
      'phn_no': phone,
      'email': email,
      'website': website,
      'address': address,
      'office_address': officeAddress,
      'instagram_link': instagram,
      'facebook_link': facebook,
      'linkedin_link': linkedin,
      'youtube_link': youtube,
    };
  }

  PortfolioData copyWith({
    int? id,
    String? description,
    String? directorMessage,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? officeAddress,
    String? instagram,
    String? facebook,
    String? linkedin,
    String? youtube,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PortfolioData(
      id: id ?? this.id,
      description: description ?? this.description,
      directorMessage: directorMessage ?? this.directorMessage,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      address: address ?? this.address,
      officeAddress: officeAddress ?? this.officeAddress,
      instagram: instagram ?? this.instagram,
      facebook: facebook ?? this.facebook,
      linkedin: linkedin ?? this.linkedin,
      youtube: youtube ?? this.youtube,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
