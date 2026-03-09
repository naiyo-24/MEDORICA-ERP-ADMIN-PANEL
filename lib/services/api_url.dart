class ApiUrl {
  // Update this base URL to your deployed backend host.
  static const String baseUrl = 'http://0.0.0.0:8000';

  static const String aboutUsBase = '/about-us';
  static const String aboutUsPost = '$aboutUsBase/post';
  static const String aboutUsGetAll = '$aboutUsBase/get-all';

  static String aboutUsUpdateById(int aboutUsId) =>
      '$aboutUsBase/update-by/$aboutUsId';

  static String aboutUsDeleteById(int aboutUsId) =>
      '$aboutUsBase/delete-by/$aboutUsId';

  // MR Onboarding
  static const String mrOnboardingBase = '/onboarding/mr';
  static const String mrOnboardingPost = '$mrOnboardingBase/post';
  static const String mrOnboardingGetAll = '$mrOnboardingBase/get-all';
  static const String mrOnboardingLogin = '$mrOnboardingBase/login';

  static String mrOnboardingGetById(String mrId) =>
      '$mrOnboardingBase/get-by/$mrId';

  static String mrOnboardingUpdateById(String mrId) =>
      '$mrOnboardingBase/update-by/$mrId';

  static String mrOnboardingDeleteById(String mrId) =>
      '$mrOnboardingBase/delete-by/$mrId';

  // Helper to get full profile photo URL
  static String getProfilePhotoUrl(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) return '';
    // If it's already a full URL, return as is
    if (photoPath.startsWith('http://') || photoPath.startsWith('https://')) {
      return photoPath;
    }
    // Otherwise, prepend the base URL
    return '$baseUrl/$photoPath';
  }
}
