class ApiUrl {
  // static const baseUrl = "http://10.10.20.26:8080/api/v1";
  static const baseUrl = "https://barber-shift-app-4n3k.vercel.app/api/v1";
  // static const networkUrl = "http://10.10.20.26:8080/api/v1";
  static const networkUrl = "https://barber-shift-app-4n3k.vercel.app/api/v1";

//deshboard data
  static const dashboardData = "$baseUrl/saloons/dashboard";

  ///================================= User Authentication url==========================
  static const login = "/auth/login";
  static const register = "/users/register";

  static const emailVerify = "/users/verify-otp";
  static const registerShop = "/users/register/saloon-owner";
  static const forgotPassword = "/users/forgot-password";
  static const verifyOtpForForgotPassword = "/users/verify-otp-forgot-password";
  static const resetPassword = "/users/update-password";

//User settings & profile info
  static const getProfile = "/users/profile";
  static const updateProfile = "/users/update-profile";
  static const getFaqs = "$baseUrl/faqs";
  static const termsAndCondition = "$baseUrl/terms-&-conditions";
  static const privacyPolicy = "$baseUrl/privacy-policy";
  static const changePassword = "/auth/change-password";
  static const deleteAccount = "/users/delete-account";
  static const getBarberReviews = "$baseUrl/reviews";
  static const getMyAllFavourites = "$baseUrl/favorites";
  static const BarberQueueCapacity = "$baseUrl/queue-capacities";

  // Feed management
  static const getAllFeed = "$baseUrl/feeds/my-feeds";
  static const createFeed = "/feeds";
  static String getFeedById({required String id}) => "$baseUrl/feeds/$id";
  static String likeFeed = "/favorites";
  static String unlikeFeed({required String id}) => "/feeds/unlike/$id";
  static String getHomeFeed = "$baseUrl/feeds";
  static String updateFeed({required String id}) => "/feeds/$id";
  static String deleteFeed({required String id}) => "$baseUrl/feeds/$id";

//job post management
  static const getAllJobPost = "$baseUrl/job-posts";
  static const getBarberOwnerJobPost = "$baseUrl/job-posts/salon-owners";
  static const createBarberOwnerJobPost = "/job-posts";
  static String getJobPostById({required String id}) =>
      "$baseUrl/job-posts/$id";
  static String updateJobPost({required String id}) => "$baseUrl/job-posts/$id";
  static String deleteJobPost({required String id}) => "$baseUrl/job-posts/$id";
  static const historyOfMyApplications =
      "$baseUrl/job-applications/my-applications";

  static const barberOwnerApplications = "$baseUrl/job-applications";

  static String updateJobApplicationStatus({required String id}) =>
      "$baseUrl/job-applications/$id";

  static String toggleJobPostStatus(
          {required String id, required String status}) =>
      "$baseUrl/job-posts/$id/$status";

  //Profile
  static const fetchProfileInfo = "$baseUrl/users/me";
  static const barberProfileFetchInfo = "$baseUrl/users/barber-profile";
  static const barberProfileUpdateInfo = "/users/update/barber";
  static const ownerProfileUpdateInfo = "$baseUrl/users/update-profile";
  static const profileImageUpload = "/users/update-profile-image";

  // Barber profile by ID
  static String barberProfileById(String barberId) =>
      "$baseUrl/barbers/$barberId";

  // Job application
  static const applyJobUri = "/job-applications";

//not used
  static const forgetOtp = "/auth/verify-otp";
  static const resendCode = "/auth/email-verification/resend-code";

  //selon management
  static getSelonData({String? userId}) =>
      "$baseUrl/saloons/all-saloons/$userId";
  static String toggleFollowSalon = "/follows";
  static String makeUnfollow({required String id}) => "$baseUrl/follows/$id";

  //scheduling management
  static const fetchBarberSchedule = "$baseUrl/barbers/my-schedule";

  // booking management
  static const getBarberBookings = "$baseUrl/barbers/my-bookings";
  static String getDateWiseBookings = "$baseUrl//bookings/list";

  // QR Code management
  static const sendQrCodeInfo = "/qr-codes";
  static const getQrCodeInfo = "$baseUrl/qr-codes";
  static const verifyQrCode = "${baseUrl}/qr-codes/verify";

  // Barber
  static const getHiredBarbers = "$baseUrl/job-applications/hired-barbers";

  //Que management
  static String getQueList({required String id}) =>
      "$baseUrl/bookings/walking-in/barbers/$id/QUEUE";

  static String fetchUserData({required String filter}) =>
      "$baseUrl/follows/$filter";
  static String getBarbersCustomerQue(
          {required String ownerId, required String barberId}) =>
      "$baseUrl/bookings/barbers/$ownerId/$barberId";
  static String onOffQueueToggle = "${baseUrl}/saloons/queue-control";

  static String getServices = "$baseUrl/services";
  static const getBarberWithDateTime = "$baseUrl/bookings/barbers";
  static const nonRegisteredBooking = "/bookings";
  static const businessProfile = "$baseUrl/users/saloon-owner-profile";
  static const updateBusinessProfile = "/users/update/saloon-owner";
}
