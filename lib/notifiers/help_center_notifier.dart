import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/help_center.dart';

class HelpCenterState {
  const HelpCenterState({required this.data, this.isLoading = false});

  final HelpCenterData data;
  final bool isLoading;

  HelpCenterState copyWith({HelpCenterData? data, bool? isLoading}) {
    return HelpCenterState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HelpCenterNotifier extends Notifier<HelpCenterState> {
  @override
  HelpCenterState build() {
    final data = _mockData();
    return HelpCenterState(data: data);
  }

  HelpCenterData _mockData() {
    return const HelpCenterData(
      companyName: 'Naiyo24 Pvt. Ltd.',
      tagline: 'Your Trusted Healthcare Partner',
      description:
          'Naiyo24 Private Limited is a leading pharmaceutical company dedicated to providing high-quality healthcare solutions. With a strong commitment to innovation and excellence, we strive to improve the health and well-being of communities across India. Our comprehensive portfolio includes a wide range of pharmaceutical products and services designed to meet the diverse needs of healthcare professionals and patients alike.',
      phone: '+91 98765 43210',
      email: 'contact@naiyo24.com',
      address:
          '123 Healthcare Avenue, Medical District, Mumbai, Maharashtra 400001, India',
      website: 'https://www.naiyo24.com',
      logoPath: 'assets/logo/naiyo24_logo.jpeg',
    );
  }
}
