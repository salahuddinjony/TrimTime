class ApiUrl {
  // static const baseUrl = "http://10.10.20.26:8080/api/v1";
  static const baseUrl = "https://barber-shift-app-4n3k.vercel.app/api/v1";
  // static const networkUrl = "http://10.10.20.26:8080/api/v1";
  static const networkUrl = "https://barber-shift-app-4n3k.vercel.app/api/v1";

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
  static const getBarberReviews = "$baseUrl/reviews/barber";
  static const getMyAllFavourites = "$baseUrl/favorites";
  static const BarberQueueCapacity = "$baseUrl/queue-capacities";

  // Feed management
  static const getAllFeed = "$baseUrl/feeds";
  static const createFeed = "/feeds";
  static String updateFeed({required String id}) => "/feeds/$id";
  static String deleteFeed({required String id}) => "$baseUrl/feeds/$id";

//not used
  static const forgetOtp = "/auth/verify-otp";
  static const resendCode = "/auth/email-verification/resend-code";
}
