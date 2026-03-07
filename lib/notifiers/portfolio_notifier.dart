import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/portfolio.dart';

class PortfolioState {
  const PortfolioState({required this.data, this.isSaving = false});

  final PortfolioData data;
  final bool isSaving;

  PortfolioState copyWith({PortfolioData? data, bool? isSaving}) {
    return PortfolioState(
      data: data ?? this.data,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class PortfolioNotifier extends Notifier<PortfolioState> {
  @override
  PortfolioState build() {
    return const PortfolioState(
      data: PortfolioData(
        description:
            'Medorica Pharma Pvt. Ltd. is committed to transforming healthcare access through robust field operations, trusted product quality, and a deep focus on doctor, chemist, and distributor partnerships across India. Our mission is to empower healthcare professionals with reliable therapeutic solutions while continuously innovating in sales excellence and patient-centric value delivery.',
        directorMessage:
            'At Medorica, we believe growth must be responsible, transparent, and people-driven. Our teams are building a resilient pharmaceutical network where every representative and manager contributes to meaningful healthcare impact. We remain dedicated to disciplined execution, ethical business conduct, and long-term relationships with our partners.',
        phone: '+91 62893 98298',
        email: 'contact@medoricapharma.com',
        website: 'https://medoricapharma.com',
        instagram: 'https://instagram.com/medoricapharma',
        facebook: 'https://facebook.com/medoricapharma',
        linkedin: 'https://linkedin.com/company/medorica-pharma',
      ),
    );
  }

  Future<void> updateDescription(String value) async {
    state = state.copyWith(isSaving: true);
    state = state.copyWith(
      isSaving: false,
      data: state.data.copyWith(description: value.trim()),
    );
  }

  Future<void> updateDirectorMessage(String value) async {
    state = state.copyWith(isSaving: true);
    state = state.copyWith(
      isSaving: false,
      data: state.data.copyWith(directorMessage: value.trim()),
    );
  }

  Future<void> updateContact({
    required String phone,
    required String email,
    required String website,
    required String instagram,
    required String facebook,
    required String linkedin,
  }) async {
    state = state.copyWith(isSaving: true);
    state = state.copyWith(
      isSaving: false,
      data: state.data.copyWith(
        phone: phone.trim(),
        email: email.trim(),
        website: website.trim(),
        instagram: instagram.trim(),
        facebook: facebook.trim(),
        linkedin: linkedin.trim(),
      ),
    );
  }
}
