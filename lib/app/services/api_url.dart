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
  static const getAllFeed = "$baseUrl/feeds/my-feeds";
  static const createFeed = "/feeds";
  static String getFeedById({required String id}) => "$baseUrl/feeds/$id";
  static String likeFeed= "/favorites";
  static String unlikeFeed({required String id}) => "/feeds/unlike/$id";
  static String getHomeFeed= "$baseUrl/feeds";
  static String updateFeed({required String id}) => "/feeds/$id";
  static String deleteFeed({required String id}) => "$baseUrl/feeds/$id";

//job post management
  static const getAllJobPost = "$baseUrl/job-posts";
  static const historyOfMyApplications = "$baseUrl/job-applications/my-applications";

  //Profile
  static const fetchProfileInfo = "$baseUrl/users/me";
  static const barberProfileFetchInfo= "$baseUrl/users/barber-profile";
  static const barberProfileUpdateInfo= "/users/update/barber";  
  static const ownerProfileUpdateInfo= "$baseUrl/users/update-profile";
  static const profileImageUpload = "/users/update-profile-image";
  
  // Barber profile by ID
  static String barberProfileById(String barberId) => "$baseUrl/barbers/$barberId";

  // Job application
  static const applyJobUri = "/job-applications";
  


//not used
  static const forgetOtp = "/auth/verify-otp";
  static const resendCode = "/auth/email-verification/resend-code";



  //selon management
  static  getSelonData({String? userId}) => "$baseUrl/saloons/all-saloons/$userId";
  static String toggleFollowSalon="/follows"; 
  static String makeUnfollow ({required String id}) => "$baseUrl/follows/$id";


}
