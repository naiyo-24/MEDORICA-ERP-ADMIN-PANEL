class ApiUrl {
  // Update this base URL to your deployed backend host.
  static const String baseUrl = 'http://0.0.0.0:8000';

  // About Us
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


  // ASM Onboarding
  static const String asmOnboardingBase = '/onboarding/asm';
  static const String asmOnboardingPost = '$asmOnboardingBase/post';
  static const String asmOnboardingGetAll = '$asmOnboardingBase/get-all';
  static const String asmOnboardingLogin = '$asmOnboardingBase/login';

  static String asmOnboardingGetById(String asmId) =>
      '$asmOnboardingBase/get-by/$asmId';

  static String asmOnboardingUpdateById(String asmId) =>
      '$asmOnboardingBase/update-by/$asmId';

  static String asmOnboardingDeleteById(String asmId) =>
      '$asmOnboardingBase/delete-by/$asmId';


  // MR Doctor Network
  static const String mrDoctorNetworkBase = '/doctor-network/mr';
  static const String mrDoctorNetworkGetAll = '$mrDoctorNetworkBase/get-all';

  static String mrDoctorNetworkGetByDoctor(String doctorId) =>
      '$mrDoctorNetworkBase/get-by-doctor/$doctorId';

  static String mrDoctorNetworkGetAllByMr(String mrId) =>
      '$mrDoctorNetworkBase/get-all-by-mr/$mrId';

  static String mrDoctorNetworkGetByMrAndDoctor(String mrId, String doctorId) =>
      '$mrDoctorNetworkBase/get-by-mr/$mrId/doctor/$doctorId';

  // Distributor Management
  static const String distributorBase = '/distributor';
  static const String distributorPost = '$distributorBase/post';
  static const String distributorGetAll = '$distributorBase/get-all';

  static String distributorGetById(String distId) =>
      '$distributorBase/get-by/$distId';

  static String distributorUpdateById(String distId) =>
      '$distributorBase/update-by/$distId';

  static String distributorDeleteById(String distId) =>
      '$distributorBase/delete-by/$distId';

  // Visual Ads Management
  static const String visualAdsBase = '/visual-ads';
  static const String visualAdsPost = '$visualAdsBase/post';
  static const String visualAdsGetAll = '$visualAdsBase/get-all';

  static String visualAdsGetById(String adId) =>
      '$visualAdsBase/get-by/$adId';

  static String visualAdsUpdateById(String adId) =>
      '$visualAdsBase/update-by/$adId';

  static String visualAdsDeleteById(String adId) =>
      '$visualAdsBase/delete-by/$adId';

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
