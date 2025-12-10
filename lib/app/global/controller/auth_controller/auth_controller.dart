import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/global/controller/password_constraint/password_constraint_controller.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/services/api_check.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';

class AuthController extends GetxController with PasswordConstraintController {
//for sign-in and sing-up
  final fullNameController = TextEditingController(text: "");

  final addressController = TextEditingController(text: "");
  final regNumberController = TextEditingController(text: "");
  final shopNameController = TextEditingController(text: "");
  
  // Store selected location from map
  double selectedLatitude = 0.0;
  double selectedLongitude = 0.0;

  // //for CUSTOMER SIGN UP
  // final emailController = TextEditingController(text: "efazkh@gmail.com");
// final passwordController = TextEditingController(text: "12345678");

  // //for Owner SIGN UP
  // final emailController = TextEditingController(text: "r3tov4uez6@zudpck.com");
  // final passwordController = TextEditingController(text: "12345678");

  // //for Barber SIGN UP
  // final emailController = TextEditingController(text: "gisiba8648@nicext.com");
  // final passwordController = TextEditingController(text: "12345678");
  final emailController = TextEditingController(text: "");
  final passwordController = TextEditingController(text: "");

  final confirmPasswordController = TextEditingController(text: "");
  final newPasswordController = TextEditingController(text: "");

  final pinCodeController = TextEditingController();

// Owner Sign In
//  final emailController =
//       TextEditingController(text: "magomaw443@obirah.com");
//   final passwordController = TextEditingController(text: "12345678");

  RxBool isRemember = false.obs;

  toggleRemember() {
    isRemember.value = !isRemember.value;
    debugPrint("Remember me==============>>>>>>>>>$isRemember");
    refresh();
    SharePrefsHelper.setBool(AppConstants.isRememberMe, isRemember.value);
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
  //>>>>>>>>>>>>>>>>>>✅✅SIgn In Method✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isSignInLoading = false.obs;

  Future<void> signIn({String? userRole}) async {
    EasyLoading.show(status: 'Signing in...');
    isSignInLoading.value = true;

    try {
      final body = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      final response = await ApiClient.postData(
        ApiUrl.login,
        jsonEncode(body),
      );

      // Safely parse response body (handle empty / non-JSON)
      dynamic resBody;
      try {
        if (response.body == null) {
          resBody = null;
        } else if (response.body is String &&
            (response.body as String).trim().isEmpty) {
          resBody = null;
        } else if (response.body is String) {
          resBody = jsonDecode(response.body);
        } else {
          resBody = response.body;
        }
      } catch (e) {
        debugPrint("Failed to parse response body: $e");
        resBody = null;
      }

      if (response.statusCode == 200 && resBody != null) {
        EasyLoading.dismiss();
        debugPrint("Response body: $resBody");

        final accessToken = resBody["data"]?['accessToken'];
        if (accessToken == null) {
          toastMessage(message: AppStrings.someThing);
          return;
        }
        debugPrint("User Details before saving token:");
        debugPrint("Access Token: $accessToken");
        debugPrint("User Data: ${resBody['data']}");
        debugPrint("User Role: ${resBody['data']?['role']}");

        Map<String, String> roles = {
          'user': 'CUSTOMER',
          'owner': 'SALOON_OWNER',
          'barber': 'BARBER',
        };

        if (resBody['data']?['role'] != roles[userRole]) {
          EasyLoading.showInfo(
              "Please sign in using the correct role: ${userRole == 'user' ? 'Customer' : userRole.safeCap()}",
              duration: const Duration(seconds: 4));
          return;
        }

        // Save token & user info
        await SharePrefsHelper.setString(AppConstants.bearerToken, accessToken);

        await SharePrefsHelper.setString(AppConstants.userId,
            resBody['data']?["id"] ?? resBody['data']?["_id"] ?? '');
        // save saloonOwnerId if present
        await SharePrefsHelper.setString(AppConstants.saloonOwnerId,
            resBody['data']?["saloonOwnerId"] ?? '');

        await SharePrefsHelper.setString(
            AppConstants.role, resBody['data']?["role"] ?? '');

        await SharePrefsHelper.setBool(AppConstants.qrCode.toString(),
            resBody['data']?["qrCode"] ?? false);

        debugPrint("User info after saved token:");
        debugPrint(
            "Saved Token: ${await SharePrefsHelper.getString(AppConstants.bearerToken)}");
        debugPrint(
            "Saved Role: ${await SharePrefsHelper.getString(AppConstants.role)}");
        debugPrint(
            "Saved User ID: ${await SharePrefsHelper.getString(AppConstants.userId)}");
        debugPrint(
            "Saved QR Code: ${await SharePrefsHelper.getBool(AppConstants.qrCode.toString())}");

        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        String roleStr = decodedToken['role'] ?? '';
        final roleEnum = getRoleFromString(roleStr);

        // Navigate with enum role
        if (roleEnum == UserRole.user) {
          AppRouter.route.goNamed(RoutePath.homeScreen, extra: roleEnum);
        } else if (roleEnum == UserRole.owner) {
          AppRouter.route.goNamed(RoutePath.ownerHomeScreen, extra: roleEnum);
        } else if (roleEnum == UserRole.barber) {
          AppRouter.route.goNamed(RoutePath.barberHomeScreen, extra: roleEnum);
        } else {
          toastMessage(message: "Unknown user role: $roleStr");
          return;
        }
        toastMessage(message: resBody["message"] ?? AppStrings.someThing);
      } else if (response.statusCode == 400) {
        EasyLoading.showError(resBody["message"] ?? AppStrings.someThing,
            duration: const Duration(seconds: 2));
        debugPrint("Response body on 400: $resBody");
      } else {
        EasyLoading.showError(
            resBody != null
                ? (resBody["error"] ?? resBody["message"])?.toString() ??
                    AppStrings.someThing
                : AppStrings.someThing,
            duration: const Duration(seconds: 2));

        try {
          ApiChecker.checkApi(response);
        } catch (e) {
          EasyLoading.showError(AppStrings.someThing);
          debugPrint("ApiChecker failed: $e");
          toastMessage(message: AppStrings.someThing);
        }
      }
    } catch (e) {
      toastMessage(message: AppStrings.someThing);
      debugPrint("SignIn Error: $e");
    } finally {
      EasyLoading.dismiss();
      isSignInLoading.value = false;
    }
  }

//==============Initial route for the app lunching,Determines the initial route based on saved token and role.=============================

  static Future<String> getInitialRoute() async {
    await SharePrefsHelper.init();

    final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
    final role = await SharePrefsHelper.getString(AppConstants.role);
    debugPrint("Saved Token: $token");
    debugPrint("Saved Role: $role");

    if (token.isNotEmpty) {
      // Check if token is expired before proceeding
      final expired = await isTokenExpired();
      if (expired) {
        debugPrint(
            "Token is expired on app startup. Clearing session and navigating to role selection.");
        // Clear expired token and user data
        await SharePrefsHelper.remove();
        await SharePrefsHelper.setBool(AppConstants.rememberMe, false);
        await SharePrefsHelper.setBool(AppConstants.isRememberMe, false);
        return RoutePath.choseRoleScreen;
      }

      debugPrint("Token exists and is valid, user is logged in.");
      if (role == 'BARBER') {
        debugPrint("User Role: BARBER, navigating to barber home.");
        return RoutePath.barberHomeScreen;
      } else if (role == 'SALOON_OWNER') {
        debugPrint("User Role: SALOON_OWNER, navigating to owner home.");
        return RoutePath.ownerHomeScreen;
      } else if (role == 'CUSTOMER') {
        debugPrint("User Role: CUSTOMER, navigating to customer home.");
        return RoutePath.homeScreen;
      }
    }
    debugPrint("No valid token found, navigating to role selection.");
    return RoutePath.choseRoleScreen;
  }

  /// Returns the saved role string from shared preferences, or empty string.
  static Future<String?> getSavedRole() async {
    try {
      await SharePrefsHelper.init();
      final role = await SharePrefsHelper.getString(AppConstants.role);
      return role;
    } catch (e) {
      debugPrint('Failed to read saved role: $e');
      return null;
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Logout Method✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  /// Centralized logout method that clears user data and navigates to role selection screen
  static Future<void> logout({bool showMessage = true}) async {
    try {
      debugPrint("Logging out user...");

      // Clear all user data from shared preferences
      await SharePrefsHelper.remove();

      // Clear remember me flag
      await SharePrefsHelper.setBool(AppConstants.rememberMe, false);
      await SharePrefsHelper.setBool(AppConstants.isRememberMe, false);

      // Clear all GetX controllers
      Get.deleteAll(force: true);

      // Navigate to role selection screen
      AppRouter.route.goNamed(RoutePath.choseRoleScreen);

      if (showMessage) {
        toastMessage(message: "Session expired. Please login again.");
      }

      debugPrint("Logout completed successfully");
    } catch (e) {
      debugPrint("Error during logout: $e");
      // Even if there's an error, try to navigate to role selection
      try {
        AppRouter.route.goNamed(RoutePath.choseRoleScreen);
      } catch (navError) {
        debugPrint("Navigation error during logout: $navError");
      }
    }
  }

  /// Check if the JWT token is expired
  static Future<bool> isTokenExpired() async {
    try {
      final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
      if (token.isEmpty) {
        return true;
      }

      // Decode JWT token to check expiration
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      bool isExpired = JwtDecoder.isExpired(token);

      if (isExpired) {
        debugPrint("Token is expired. Expiration time: ${decodedToken['exp']}");
        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Error checking token expiration: $e");
      // If we can't decode the token, consider it expired
      return true;
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Forget password In Method✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isForgetLoading = false.obs;

  Future<void> forgetPassword() async {
    isForgetLoading.value = true;
    EasyLoading.show(status: 'Processing...');

    try {
      final body = {
        "email": emailController.text.trim(),
      };

      final response = await ApiClient.postData(
        ApiUrl.forgotPassword,
        jsonEncode(body),
      );

      if (response.statusCode == 200) {
        toastMessage(message: response.body["message"]);
        debugPrint("Forget Password Response: ${response.body}");
        EasyLoading.dismiss();
        debugPrint("Response body: ${response.body}");

        AppRouter.route.pushNamed(
          RoutePath.otpScreen,
          extra: {
            "isForget": false,
            "email": emailController.text,
            "isForgotPassword": true,
          },
        );

        toastMessage(message: response.body["message"]);
      } else if (response.statusCode == 400) {
        EasyLoading.showError(response.body["error"]);
      } else {
        EasyLoading.showError(response.body["message"] ?? AppStrings.someThing);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      toastMessage(message: AppStrings.someThing);
      debugPrint("SignIn Error: $e");
    } finally {
      EasyLoading.dismiss();
      isSignInLoading.value = false;
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Forget Otp ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  String resetCode = "";
  RxBool isForgetOtp = false.obs;
  // final pinCodeController = TextEditingController();

  Future<void> forgetOtp() async {
    if (resetCode.isEmpty) {
      toastMessage(message: "Please enter the activation code.");
      return;
    }

    isForgetOtp.value = true;
    refresh();

    Map<String, String> body = {
      "email": emailController.text.trim(),
      "otp": resetCode
    };
    var response = await ApiClient.postData(ApiUrl.forgetOtp, jsonEncode(body));
    isForgetOtp.value = false;
    refresh();

    if (response.statusCode == 200) {
      AppRouter.route.goNamed(RoutePath.resetPasswordScreen);
      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["error"]);
    } else {
      ApiChecker.checkApi(response);
      debugPrint("Error: ${response.body["message"]}");
    }
    isForgetOtp.value = false;
    refresh();
  }

  //>>>>>>>>>>>>>>>>>>✅✅Delete Account✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isDeletingLoading = false.obs;

  Future<void> deleteAccount(String password, String confirmPassword) async {
    debugPrint("Delete account called with email: $confirmPassword");
    debugPrint("Password length: ${password}");

    if (confirmPassword.isEmpty || password.isEmpty) {
      EasyLoading.showInfo("Please fill all fields.");
      return;
    }

    if (password.trim() != confirmPassword.trim()) {
      EasyLoading.showInfo("Password and Confirm Password do not match.");
      return;
    }

    isDeletingLoading.value = true;
    refresh();

    final Map<String, String> body = {
      // // "fullName": name.trim(),
      // "email": email.trim(),
      "password": password,
    };
    EasyLoading.show(status: 'Deleting account...');

    var response =
        await ApiClient.postData(ApiUrl.deleteAccount, jsonEncode(body));
    dynamic resBody = response.body;
    try {
      if (resBody is String && resBody.trim().isNotEmpty) {
        resBody = jsonDecode(resBody);
      }
    } catch (e) {
      debugPrint('Failed to parse deleteAccount response: $e');
    }

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      AppRouter.route.goNamed(RoutePath.choseRoleScreen);
      toastMessage(message: resBody?["message"] ?? AppStrings.someThing);
    } else if (response.statusCode == 400) {
      EasyLoading.showError(
          resBody?['error'] ?? resBody?['message'] ?? AppStrings.someThing);
      toastMessage(
          message:
              resBody?['error'] ?? resBody?['message'] ?? AppStrings.someThing);
    } else {
      EasyLoading.showError(resBody?['message'] ?? AppStrings.someThing);
      ApiChecker.checkApi(response);
      debugPrint("Error: ${resBody?["message"]}");
    }

    isDeletingLoading.value = false;
    refresh();
  }

  //>>>>>>>>>>>>>>>>>>✅✅Reset Password✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  RxBool isResetLoading = false.obs;

  Future<void> resetPassword({required String email}) async {
    // isResetLoading.value = true;
    // refresh();
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      toastMessage(message: "Password and Confirm Password do not match.");
      return;
    }
    EasyLoading.show(status: 'Resetting password...');
    final Map<String, dynamic> body = {
      "email": email,
      "password": passwordController.text.trim(),
    };

    // Ensure we send a proper JSON payload and Content-Type header.
    var response = await ApiClient().putData(
      ApiUrl.resetPassword,
      body,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      AppRouter.route.goNamed(
        RoutePath.signInScreen,
      );
      toastMessage(
        message: response.body["message"],
      );
      clearControllers();
    } else {
      EasyLoading.showError(response.body["message"] ?? AppStrings.someThing);
      ApiChecker.checkApi(response);
    }
    isResetLoading.value = false;
    refresh();
  }

  //>>>>>>>>>>>>>>>>>>Change Password✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  RxBool isChangepassLoading = false.obs;

  Future<void> changePassword() async {
    // isChangepassLoading.value = true;
    // refresh();
    if (passwordController.text.trim().isEmpty ||
        newPasswordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      EasyLoading.showInfo("Please fill all fields.");
      return;
    }

    if (newPasswordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      EasyLoading.showError("Password and Confirm Password do not match.");
      return;
    }

    if (passwordController.text.trim() == newPasswordController.text.trim()) {
      EasyLoading.showError(
          "New password cannot be the same as current password.");
      return;
    }

    EasyLoading.show(status: 'Changing password...');
    // Backend expects the new password under the key `password` (same as resetPassword).
    // Include oldPassword for verification and email for identification.
    final Map<String, dynamic> body = {
      "oldPassword": passwordController.text.trim(),
      "newPassword": newPasswordController.text.trim(),
      // "email": saveEmail,
    };

    // Ensure we send a proper JSON payload and Content-Type header.
    var response = await ApiClient().putData(
      ApiUrl.changeUserPassword,
      body,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      passwordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      AppRouter.route.pop();
      toastMessage(
        message: response.body["message"],
      );
    } else {
      EasyLoading.showError(response.body["message"] ?? AppStrings.someThing);
      ApiChecker.checkApi(response);
    }
    isChangepassLoading.value = false;
    refresh();
  }

  //>>>>>>>>>>>>>>>>>>✅✅Sign up CUSTOMER/ BARBER<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  Future<void> signUp({required String role}) async {
    if (passwordController.text != confirmPasswordController.text) {
      toastMessage(message: "Password and Confirm Password do not match.");
      return;
    }
    // Convert the incoming role name (e.g. 'user', 'barber', 'owner') to our enum
    UserRole selectedRole;
    try {
      selectedRole = UserRole.values.firstWhere((e) => e.name == role);
    } catch (_) {
      selectedRole = UserRole.user;
    }

    // Convert to API expected role string (CUSTOMER | SALOON_OWNER | BARBER)

    final apiRole = apiRoleFromUserRole(selectedRole);
    debugPrint("Selected Role for SignUp (api): $apiRole");

    Map<String, dynamic> body = {
      "fullName": fullNameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "intendedRole": apiRole,
    };

    try {
      debugPrint("SignUp Body: $body");
      EasyLoading.show(status: 'Signing up...');

      var response = await ApiClient.postData(
        ApiUrl.register,
        jsonEncode(body),
      );

      // Safely parse response body
      dynamic responseData;
      try {
        if (response.body == null) {
          responseData = null;
        } else if (response.body is String &&
            (response.body as String).trim().isEmpty) {
          responseData = null;
        } else if (response.body is String) {
          responseData = jsonDecode(response.body);
        } else {
          responseData = response.body;
        }
      } catch (e) {
        debugPrint("Failed to parse signup response: $e");
        responseData = null;
      }

      if (response.statusCode == 201 && responseData != null) {
        EasyLoading.dismiss();
        debugPrint("Response Data: $responseData");

        apiRole == 'SALOON_OWNER'
            ? AppRouter.route.pushNamed(
                RoutePath.otpScreen,
                extra: {
                  "isOwner": true,
                  "email": emailController.text,
                  "userRole": selectedRole.name,
                },
              )
            : AppRouter.route.pushNamed(
                RoutePath.otpScreen,
                extra: {
                  "isOwner": false,
                  "email": emailController.text,
                  "userRole": selectedRole.name,
                },
              );

        toastMessage(message: responseData["message"] ?? AppStrings.someThing);
      } else if (response.statusCode == 400) {
        final err = responseData != null
            ? (responseData["error"] ?? responseData["message"])?.toString() ??
                AppStrings.someThing
            : AppStrings.someThing;
        EasyLoading.showError(err);
        debugPrint("Response body on 400: $responseData");
      } else {
        final err = responseData != null
            ? (responseData["error"] ?? responseData["message"])?.toString() ??
                AppStrings.someThing
            : AppStrings.someThing;
        EasyLoading.showError(err);
        debugPrint("Response body: $responseData");
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      EasyLoading.showError(AppStrings.someThing);
      debugPrint("SignUp Error: $e");
    } finally {
      EasyLoading.dismiss();
    }

    refresh();
  }

//>>>>>>>>>>>>>>>>>>✅✅SIgn up SALOON_OWNER, BARBER<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

//================= Owner/Barber Shop Registration (Multipart POST) =================

  Rx<File?> selectedShopLogo = Rx<File?>(null);
  final RxList<File> shopImages = <File>[].obs;
  final RxBool isShopRegisterLoading = false.obs;

// Pick shop logo (single image)
  Future<void> pickShopLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedShopLogo.value = File(picked.path);
    }
  }

// Pick multiple shop images
  Future<void> pickShopImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      shopImages.assignAll(pickedFiles.map((e) => File(e.path)));
    }
  }

// Register shop (POST multipart)
  Future<void> registerShop({String? email}) async {
    if (selectedShopLogo.value == null) {
      toastMessage(message: "Please select a shop logo.");
      return;
    }
    if (shopImages.isEmpty) {
      toastMessage(message: "Please select at least one shop image.");
      return;
    }
    if (fullNameController.text.trim().isEmpty ||
        regNumberController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      toastMessage(message: "Please fill all required fields.");
      return;
    }

    // isShopRegisterLoading.value = true;
    // refresh();

    // Use selected location from map, or fallback to default (Dhaka)
    final double latitude = selectedLatitude != 0.0 
        ? selectedLatitude 
        : (double.tryParse("23.8103") ?? 23.8103); // Dhaka approx
    final double longitude = selectedLongitude != 0.0 
        ? selectedLongitude 
        : (double.tryParse("90.4125") ?? 90.4125); // Dhaka approx

    final Map<String, dynamic> bodyData = {
      "email": email ?? emailController.text.trim(),
      "shopName": shopNameController.text.trim(),
      "registrationNumber": regNumberController.text.trim(),
      "shopAddress": addressController.text.trim(),
      "latitude": latitude,
      "longitude": longitude,
    };
    EasyLoading.show(status: 'Registering shop...');

    try {
      final File? logoFile = selectedShopLogo.value;
      if (logoFile == null) {
        toastMessage(message: "Please select a shop logo.");
        isShopRegisterLoading.value = false;
        refresh();
        return;
      }

      final multipartList = <MultipartBody>[
        MultipartBody("shop_logo", logoFile),
        ...shopImages.map((img) => MultipartBody("shop_images", img)),
      ];

      final response = await ApiClient.postMultipartData(
        ApiUrl.registerShop,
        {
          "bodyData": jsonEncode(bodyData),
        },
        multipartBody: multipartList,
      );

      dynamic responseData;
      try {
        if (response.body == null) {
          responseData = null;
        } else if (response.body is String &&
            (response.body as String).trim().isEmpty) {
          responseData = null;
        } else if (response.body is String) {
          responseData = jsonDecode(response.body);
        } else {
          responseData = response.body;
        }
      } catch (e) {
        debugPrint("Failed to parse shop register response: $e");
        responseData = null;
      }

      // Extract server-provided message (if any) to show to the user
      String? serverMessage;
      try {
        if (responseData != null) {
          if (responseData is Map) {
            serverMessage =
                (responseData['message'] ?? responseData['error'])?.toString();
          } else if (responseData is String) {
            try {
              final parsed = jsonDecode(responseData);
              if (parsed is Map) {
                serverMessage =
                    (parsed['message'] ?? parsed['error'])?.toString();
              }
            } catch (_) {
              // ignore
            }
          }
        }
      } catch (_) {
        serverMessage = null;
      }

      // If response indicated success textually, show success
      if (response.statusCode == 201) {
        EasyLoading.showSuccess(
            serverMessage ?? 'Shop registered successfully.');
      }

      if (response.statusCode == 201 && responseData != null) {
        EasyLoading.dismiss();
        debugPrint("Shop Register Response: $responseData");

        toastMessage(
            message:
                responseData["message"] ?? "Shop registered successfully.");
        
        // Clear all shop registration fields after successful registration
        clearShopRegistrationFields();
        
        // AppRouter.route.goNamed(RoutePath.ownerHomeScreen, extra: UserRole.owner);
        AppRouter.route.goNamed(RoutePath.signInScreen, extra: UserRole.owner);
      } else if (response.statusCode == 400) {
        debugPrint('Register shop failed, response body: $responseData');
        final errMsg = responseData != null
            ? (responseData["message"] ??
                responseData["error"] ??
                responseData.toString())
            : (response.statusText ?? "Registration failed.");
        EasyLoading.showError(serverMessage ?? errMsg);
        debugPrint("Shop Register Error: $errMsg");
        // Build issues list if available
        String issuesText = "";
        try {
          if (responseData != null &&
              responseData["errorDetails"] != null &&
              responseData["errorDetails"]["issues"] != null) {
            final issues = responseData["errorDetails"]["issues"];
            if (issues is List) {
              issuesText =
                  issues.map((i) => "${i["path"]}: ${i["message"]}").join('\n');
            }
          }
          EasyLoading.showError(errMsg);
        } catch (e) {
          EasyLoading.showError(errMsg);
          debugPrint('Failed to build issues text: $e');
        }
        EasyLoading.showError(errMsg);
        // Show both toast and dialog for clarity
        toastMessage(message: errMsg);
        if (issuesText.isNotEmpty) {
          // Guard against Get.context being null (prevents 'Null check operator used on a null value')
          if (Get.context != null) {
            try {
              Get.defaultDialog(
                title: 'Registration Failed',
                middleText: '$errMsg\n\nDetails:\n$issuesText',
                textConfirm: 'OK',
                onConfirm: () => Get.back(),
              );
            } catch (e, st) {
              debugPrint('Failed to show dialog: $e');
              debugPrint('$st');
            }
          } else {
            debugPrint(
                'Get.context is null — cannot show dialog. Details: $issuesText');
          }
        }
      } else {
        EasyLoading.showError(serverMessage ?? 'Sorry, something went wrong.');
        debugPrint("Shop Register Unexpected Response: ${response.body}");
        try {
          ApiChecker.checkApi(response);
        } catch (e) {
          debugPrint('ApiChecker failed: $e');
        }
      }
    } catch (e, st) {
      EasyLoading.showError('Sorry, something went wrong.');
      toastMessage(message: "Something went wrong.");
      debugPrint("Shop Register Error: $e");
      debugPrint("Stacktrace: $st");
    } finally {
      EasyLoading.dismiss();
      isShopRegisterLoading.value = false;
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>> Account Active Otp  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  var saveEmail = '';
  RxBool isActiveLoading = false.obs;

  Future<void> userAccountActiveOtp(
      {bool? isOwner, bool? isForgotPassword, UserRole? userRole}) async {
    if (pinCodeController.text.trim().isEmpty) {
      toastMessage(message: "Please enter the activation code.");
      return;
    }

    isActiveLoading.value = true;
    refresh();

    final otpValue = int.tryParse(pinCodeController.text.trim());
    if (otpValue == null) {
      toastMessage(message: "Invalid OTP format.");
      isActiveLoading.value = false;
      refresh();
      return;
    }
    EasyLoading.show(status: 'Verifying OTP...');

    Map<String, dynamic> body = {
      "email": emailController.text.trim(),
      "otp": otpValue
    };
    final url = (isForgotPassword ?? false)
        ? ApiUrl.verifyOtpForForgotPassword
        : ApiUrl.emailVerify;
    debugPrint("Verifying OTP at $url with body: $body");

    var apiClient = ApiClient();
    var response = await apiClient
        .putData(url, body, headers: {"Content-Type": "application/json"});

    // parse response safely
    dynamic respBody;
    try {
      if (response.body == null) {
        respBody = null;
      } else if (response.body is String &&
          (response.body as String).trim().isEmpty) {
        respBody = null;
      } else if (response.body is String) {
        respBody = jsonDecode(response.body);
      } else {
        respBody = response.body;
      }
    } catch (e) {
      debugPrint('Failed to parse verify response: $e');
      respBody = null;
    }

    isActiveLoading.value = false;
    refresh();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();

      pinCodeController.clear();

      if (isOwner != null && isOwner) {
        AppRouter.route.goNamed(RoutePath.ownerShopDetails,
            extra: {"email": emailController.text.trim()});
      } else if (isForgotPassword != null && isForgotPassword) {
        AppRouter.route.goNamed(RoutePath.resetPasswordScreen, extra: {
          "email": emailController.text.trim(),
          "userRole": isOwner == true ? UserRole.owner : UserRole.user
        });
      } else {
        emailController.clear();
        AppRouter.route.goNamed(RoutePath.signInScreen, extra: userRole);
      }

      final msg = respBody != null
          ? (respBody['message'] ?? respBody['msg'] ?? respBody['success'])
              ?.toString()
          : response.statusText;
      toastMessage(message: msg ?? AppStrings.someThing);
      saveEmail = emailController.text;
      clearControllers();
    } else if (response.statusCode == 400) {
      EasyLoading.showError(
        respBody != null
            ? ((respBody['error'] ?? respBody['message'])?.toString() ??
                AppStrings.someThing)
            : AppStrings.someThing,
      );
      pinCodeController.clear();
      final err = respBody != null
          ? (respBody['error'] ?? respBody['message'])?.toString()
          : response.statusText;
      toastMessage(message: err ?? AppStrings.someThing);

      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      pinCodeController.clear();
      ApiChecker.checkApi(response);
      final debugMsg =
          respBody != null ? respBody['message'] ?? respBody : null;
      debugPrint("Error: $debugMsg");
    }
    isActiveLoading.value = false;
    refresh();
  }

  //>>>>>>>>>>>>>>>>>>✅✅ Account Active ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  String vendorActivationCode = "";
  RxBool vendorIsActiveLoading = false.obs;

  Future<void> vendorAccountActiveOtp() async {
    if (vendorActivationCode.isEmpty) {
      toastMessage(message: "Please enter the activation code.");
      return;
    }

    vendorIsActiveLoading.value = true;
    refresh();

    final otpValue = int.tryParse(vendorActivationCode.trim());
    if (otpValue == null) {
      toastMessage(message: "Invalid OTP format.");
      vendorIsActiveLoading.value = false;
      refresh();
      return;
    }

    Map<String, dynamic> body = {
      // "email": businessEmailController.text.trim(),
      "otp": otpValue
    };

    // Use PUT and send JSON content so backend receives numeric OTP
    var response = await ApiClient().putData(ApiUrl.emailVerify, body,
        headers: {"Content-Type": "application/json"});
    vendorIsActiveLoading.value = false;
    refresh();

    if (response.statusCode == 200) {
      // businessEmailController.clear();

      AppRouter.route.goNamed(RoutePath.signInScreen, extra: UserRole.owner);
      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      pinCodeController.clear();
      toastMessage(message: response.body["error"]);
    } else {
      ApiChecker.checkApi(response);
      debugPrint("Error: ${response.body["message"]}");
    }
    vendorIsActiveLoading.value = false;
    refresh();
  }

  @override
  void onInit() {
    super.onInit();
  }

  /// Clear all shop registration fields
  void clearShopRegistrationFields() {
    shopNameController.clear();
    regNumberController.clear();
    addressController.clear();
    selectedShopLogo.value = null;
    shopImages.clear();
    selectedLatitude = 0.0;
    selectedLongitude = 0.0;
    isRemember.value = false;
    // Note: fullNameController is not cleared as it might be used in other screens
    debugPrint('All shop registration fields cleared');
  }

  /// into [regNumberController]. This uses timestamp + random
  void generateRegistrationNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    // keep it short: use last 4 digits of timestamp + 2 random chars
    final tsPart = (timestamp % 10000).toString().padLeft(5, '0');
    final randomPart =
        (DateTime.now().microsecond % 90 + Random().nextInt(90)).toString();
    final code = 'REG$tsPart$randomPart' +
        shopNameController.text.trim().substring(0, 5).toUpperCase();
    regNumberController.text = code;
    debugPrint('Generated registration number: $code');
    refresh();
  }
}
