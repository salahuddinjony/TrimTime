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




//User settings 

static const getFaqs = "$baseUrl/faqs";
static const termsAndCondition= "$baseUrl/terms-&-conditions";
static const privacyPolicy= "$baseUrl/privacy-policy";


//not used
  static const forgetOtp = "/auth/verify-otp";
  static const resendCode = "/auth/email-verification/resend-code";

  static const changePassword = "/auth/change-password";
  // Account deletion (not originally present) - backend may expose a DELETE on /users/delete or /users
  // Add a constant here so callers can use a single source. Adjust value if backend expects a different path.
  static const deleteAccount = "/users/delete-account";
}
