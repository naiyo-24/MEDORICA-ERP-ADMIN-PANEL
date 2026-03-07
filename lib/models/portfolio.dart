class PortfolioData {
  const PortfolioData({
    required this.description,
    required this.directorMessage,
    required this.phone,
    required this.email,
    required this.website,
    required this.instagram,
    required this.facebook,
    required this.linkedin,
  });

  final String description;
  final String directorMessage;

  final String phone;
  final String email;
  final String website;
  final String instagram;
  final String facebook;
  final String linkedin;

  PortfolioData copyWith({
    String? description,
    String? directorMessage,
    String? phone,
    String? email,
    String? website,
    String? instagram,
    String? facebook,
    String? linkedin,
  }) {
    return PortfolioData(
      description: description ?? this.description,
      directorMessage: directorMessage ?? this.directorMessage,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      instagram: instagram ?? this.instagram,
      facebook: facebook ?? this.facebook,
      linkedin: linkedin ?? this.linkedin,
    );
  }
}
