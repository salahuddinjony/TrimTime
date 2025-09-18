class ApiUrl {
  // static const baseUrl = "http://10.10.20.26:8080/api/v1";
  static const baseUrl = "https://barber-shift-app-4n3k.vercel.app/api/v1";
  // static const networkUrl = "http://10.10.20.26:8080/api/v1";
  static const networkUrl = "https://barber-shift-app-4n3k.vercel.app/api/v1";

  

  ///================================= User Authentication url==========================
  static const login = "/auth/login";
  static const register = "/users/register";


  static const forgetPassword = "/auth/forget-password/send-otp";
  static const emailVerify = "/users/verify-otp";
  static const forgetOtp = "/auth/verify-otp";
  static const resendCode = "/auth/email-verification/resend-code";
  static const resetPassword = "/auth/reset-password";
  static const changePassword = "/auth/change-password";
  static const registerShop = "/users/register/saloon-owner";




}

