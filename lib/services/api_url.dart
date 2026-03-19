class ApiUrl {
    
  // Update this base URL to your deployed backend host.
  static const String baseUrl = 'https://appbackend.medoricapharma.com';

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
  
  // ASM Monthly Target
  static const String asmMonthlyTargetBase = '/monthly-target/asm';
  static const String asmMonthlyTargetGetAll = '$asmMonthlyTargetBase/get-all';
  static String asmMonthlyTargetGetByAsm(String asmId) => '$asmMonthlyTargetBase/get-by-asm/$asmId';
  static String asmMonthlyTargetGetByAsmYearMonth(String asmId, int year, int month) => '$asmMonthlyTargetBase/get-by/$asmId/$year/$month';
            
  // MR Salary Slip
  static const String mrSalarySlipBase = '/salary-slip/mr';
  static const String mrSalarySlipGetAll = '$mrSalarySlipBase/get-all';

  // MR Monthly Plan
  static const String mrMonthlyPlanBase = '/monthly-plan';
  static const String mrMonthlyPlanGetAll = '$mrMonthlyPlanBase/get-all';
  static String mrMonthlyPlanGetById(int planId) => '$mrMonthlyPlanBase/get-by/$planId';
  static String mrMonthlyPlanGetByMr(String mrId) => '$mrMonthlyPlanBase/get-by-mr/$mrId';
  static String mrMonthlyPlanGetByMrAndDate(String mrId, String planDate) => '$mrMonthlyPlanBase/get-by-mr/$mrId/date/$planDate';
  static String mrMonthlyPlanDeleteById(int planId) => '$mrMonthlyPlanBase/delete/$planId';
  
  // MR Salary Slip
  static String mrSalarySlipPostByMr(String mrId) => '$mrSalarySlipBase/post/$mrId';
  static String mrSalarySlipUpdateByMr(String mrId) => '$mrSalarySlipBase/update-by/$mrId';
  static String mrSalarySlipGetByMr(String mrId) => '$mrSalarySlipBase/get-by-mr/$mrId';
  static String mrSalarySlipDownloadByMr(String mrId) => '$mrSalarySlipBase/download-by-mr/$mrId';
  static String mrSalarySlipGetById(int slipId) => '$mrSalarySlipBase/get-by/$slipId';
  static String mrSalarySlipDownloadById(int slipId) => '$mrSalarySlipBase/download-by/$slipId';
  
  static String mrSalarySlipDeleteById(int slipId) => '$mrSalarySlipBase/delete-by/$slipId';
  // MR Doctor Network
  static const String mrDoctorNetworkBase = '/doctor-network/mr';
  static const String mrDoctorNetworkGetAll = '$mrDoctorNetworkBase/get-all';

  static String mrDoctorNetworkGetByDoctor(String doctorId) =>
      '$mrDoctorNetworkBase/get-by-doctor/$doctorId';

  static String mrDoctorNetworkGetAllByMr(String mrId) =>
      '$mrDoctorNetworkBase/get-all-by-mr/$mrId';

  static String mrDoctorNetworkGetByMrAndDoctor(String mrId, String doctorId) =>
      '$mrDoctorNetworkBase/get-by-mr/$mrId/doctor/$doctorId';

  // ASM Doctor Network
  static const String asmDoctorNetworkBase = '/doctor-network/asm';
  static const String asmDoctorNetworkGetAll = '$asmDoctorNetworkBase/get-all';
  static String asmDoctorNetworkGetByAsm(String asmId) => '$asmDoctorNetworkBase/get-by-asm/$asmId';
  static String asmDoctorNetworkGetByAsmAndDoctor(String asmId, String doctorId) => '$asmDoctorNetworkBase/get-by/$asmId/$doctorId';

    // ASM Chemist Shop Network
    static const String asmChemistShopBase = '/chemist-shop/asm';
    static const String asmChemistShopGetAll = '$asmChemistShopBase/get-all';
    static String asmChemistShopGetByAsm(String asmId) => '$asmChemistShopBase/get-by-asm/$asmId';
    static String asmChemistShopGetByAsmAndShop(String asmId, String shopId) => '$asmChemistShopBase/get-by/$asmId/$shopId';
    static String asmChemistShopGetByShopId(String shopId) => '$asmChemistShopBase/get-by-shop/$shopId';

    // MR Chemist Shop Network
    static const String mrChemistShopBase = '/chemist-shop/mr';
    static const String mrChemistShopGetAll = '$mrChemistShopBase/get-all';
    static String mrChemistShopGetByMR(String mrId) => '$mrChemistShopBase/get-by-mr/$mrId';
    static String mrChemistShopGetByMRAndShop(String mrId, String shopId) => '$mrChemistShopBase/get-by/$mrId/$shopId';
    static String mrChemistShopGetByShopId(String shopId) => '$mrChemistShopBase/get-by-shop/$shopId';

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

  // Gift Inventory Management
  static const String giftInventoryBase = '/gift-inventory';
  static const String giftInventoryPost = '$giftInventoryBase/post';
  static const String giftInventoryGetAll = '$giftInventoryBase/get-all';

  static String giftInventoryGetById(int giftId) =>
      '$giftInventoryBase/get-by/$giftId';

  static String giftInventoryUpdateById(int giftId) =>
      '$giftInventoryBase/update-by/$giftId';

  static String giftInventoryDeleteById(int giftId) =>
      '$giftInventoryBase/delete-by/$giftId';

  // Visual Ads Management
  static const String visualAdsBase = '/visual-ads';
  static const String visualAdsPost = '$visualAdsBase/post';
  static const String visualAdsGetAll = '$visualAdsBase/get-all';

  static String visualAdsGetById(String adId) => '$visualAdsBase/get-by/$adId';

  static String visualAdsUpdateById(String adId) =>
      '$visualAdsBase/update-by/$adId';

  static String visualAdsDeleteById(String adId) =>
      '$visualAdsBase/delete-by/$adId';

  // Team Management
  static const String teamBase = '/team';
  static const String teamPost = '$teamBase/post';
  static const String teamGetAll = '$teamBase/get-all';

  static String teamGetById(int teamId) => '$teamBase/get-by/$teamId';

  static String teamUpdateById(int teamId) => '$teamBase/update-by/$teamId';

  static String teamDeleteById(int teamId) => '$teamBase/delete-by/$teamId';

  // Notifications
  static const String notificationBase = '/notifications';
  static const String notificationPost = '$notificationBase/post';
  static const String notificationGetAll = '$notificationBase/get-all';

  static String notificationGetById(int notificationId) =>
      '$notificationBase/get-by/$notificationId';

  // ASM Salary Slip
  static const String asmSalarySlipBase = '/salary-slip/asm';
  static const String asmSalarySlipGetAll = '$asmSalarySlipBase/get-all';

  static String asmSalarySlipPostByAsm(String asmId) =>
      '$asmSalarySlipBase/post/$asmId';

  static String asmSalarySlipUpdateByAsm(String asmId) =>
      '$asmSalarySlipBase/update-by/$asmId';

  static String asmSalarySlipGetByAsm(String asmId) =>
      '$asmSalarySlipBase/get-by-asm/$asmId';

  static String asmSalarySlipDownloadByAsm(String asmId) =>
      '$asmSalarySlipBase/download-by-asm/$asmId';

  static String asmSalarySlipGetById(int slipId) =>
      '$asmSalarySlipBase/get-by/$slipId';

  static String asmSalarySlipDownloadById(int slipId) =>
      '$asmSalarySlipBase/download-by/$slipId';

  static String asmSalarySlipDeleteById(int slipId) =>
      '$asmSalarySlipBase/delete-by/$slipId';

  // ASM Orders
  static const String asmOrderBase = '/order/asm';
  static const String asmOrderGetAll = '$asmOrderBase/get-all';

  static String asmOrderGetByAsm(String asmId) =>
      '$asmOrderBase/get-by-asm/$asmId';

  static String asmOrderGetByAsmAndOrderId(String asmId, String orderId) =>
      '$asmOrderBase/get-by/$asmId/$orderId';

  static String asmOrderUpdateByOrderId(String orderId) =>
      '$asmOrderBase/update-by/$orderId';

  static String asmOrderDeleteByOrderId(String orderId) =>
      '$asmOrderBase/delete-by/$orderId';
  
  // MR Attendance
  static const String mrAttendanceBase = '/attendance/mr';
  static const String mrAttendanceGetAll = '$mrAttendanceBase/get-all';
  static String mrAttendanceGetByMrId(String mrId) => '$mrAttendanceBase/get-by/$mrId';
  static String mrAttendanceGetByMrIdAndAttendanceId(String mrId, int attendanceId) => '$mrAttendanceBase/get-by/$mrId/$attendanceId';
  static String mrAttendanceUpdateByMrIdAndAttendanceId(String mrId, int attendanceId) => '$mrAttendanceBase/update-by/$mrId/$attendanceId';
  static String mrAttendanceDeleteByAttendanceId(int attendanceId) => '$mrAttendanceBase/delete-by/$attendanceId';
  
  // ASM Attendance
  static const String asmAttendanceBase = '/attendance/asm';
  static const String asmAttendanceGetAll = '$asmAttendanceBase/get-all';
  static String asmAttendanceGetByAsmId(String asmId) => '$asmAttendanceBase/get-by/$asmId';
  static String asmAttendanceGetByAsmIdAndAttendanceId(String asmId, int attendanceId) => '$asmAttendanceBase/get-by/$asmId/$attendanceId';
  static String asmAttendanceUpdateByAsmIdAndAttendanceId(String asmId, int attendanceId) => '$asmAttendanceBase/update-by/$asmId/$attendanceId';
  static String asmAttendanceDeleteByAttendanceId(int attendanceId) => '$asmAttendanceBase/delete-by/$attendanceId';
        
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
