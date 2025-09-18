import 'dart:convert';
import 'dart:io';

import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/global/controller/password_constraint/password_constraint_controller.dart';
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

  final fullNameController = TextEditingController(text: "Salah Uddin");

  // //for CUSTOMER SIGN UP
  // final emailController = TextEditingController(text: "efazkh@gmail.com");
  // final passwordController = TextEditingController(text: "12345678");

  // //for Owner SIGN UP
  // final emailController = TextEditingController(text: "lijov22505@obirah.com");
  // final passwordController = TextEditingController(text: "12345678");

  // //for Barber SIGN UP
  final emailController =
      TextEditingController(text: "xotovip516@merumart.com");
  final passwordController = TextEditingController(text: "12345678");

  final confirmPasswordController = TextEditingController(text: "12345678");

  final pinCodeController = TextEditingController();

  RxBool isRemember = false.obs;

  toggleRemember() {
    isRemember.value = !isRemember.value;
    debugPrint("Remember me==============>>>>>>>>>$isRemember");
    refresh();
    SharePrefsHelper.setBool(AppConstants.isRememberMe, isRemember.value);
  }

  //>>>>>>>>>>>>>>>>>>✅✅SIgn In Method✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isSignInLoading = false.obs;

  Future<void> signIn() async {
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

        debugPrint("Access Token: $accessToken");
        debugPrint("User Data: ${resBody['data']}");
        debugPrint("User Role: ${resBody['data']?['role']}");

        // Save token & user info
        await SharePrefsHelper.setString(AppConstants.bearerToken, accessToken);

        await SharePrefsHelper.setString(
            AppConstants.userId, resBody['data']?["_id"] ?? '');
        await SharePrefsHelper.setString(
            AppConstants.role, resBody['data']?["role"] ?? '');

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
        EasyLoading.showError('Sign in failed');
        debugPrint("Response body on 400: $resBody");
        final errorMsg = (resBody != null && resBody["error"] != null)
            ? resBody["error"]
            : AppStrings.someThing;
        toastMessage(message: errorMsg);
      } else {
        EasyLoading.showError(AppStrings.someThing);
        // ApiChecker may expect a valid response body; guard it to avoid crashes
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

//==============Initial route for the app lunching-============

  static Future<String> getInitialRoute() async {
    await SharePrefsHelper.init();

    final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
    final role = await SharePrefsHelper.getString(AppConstants.role);

    if (token.isNotEmpty) {
      if (role == 'vendor') {
        return RoutePath.homeScreen;
      } else if (role == 'client') {
        // return RoutePath.userHomeScreen;
      }
    }
    return RoutePath.signInScreen;
    // return RoutePath.chooseAuthScreen;
  }

  //>>>>>>>>>>>>>>>>>>✅✅Forget In Method✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isForgetLoading = false.obs;

  Future<void> forgetMethod() async {
    isForgetLoading.value = true;

    try {
      final body = {
        "email": emailController.text.trim(),
      };

      final response = await ApiClient.postData(
        ApiUrl.forgetPassword,
        jsonEncode(body),
      );

      if (response.statusCode == 200) {
        AppRouter.route.pushNamed(
          RoutePath.otpScreen,
          extra: {
            "isForget": false,
            "email": emailController.text,
          },
        );

        toastMessage(message: response.body["message"]);
      } else if (response.statusCode == 400) {
        toastMessage(message: response.body["error"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      toastMessage(message: AppStrings.someThing);
      debugPrint("SignIn Error: $e");
    } finally {
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

  //>>>>>>>>>>>>>>>>>>✅✅Reset Password✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  RxBool isResetLoading = false.obs;

  Future<void> resetPassword() async {
    isResetLoading.value = true;
    refresh();
    Map<String, String> body = {
      "email": emailController.text.trim(),
      // "newPassword": passWordController.text.trim()
    };
    var response = await ApiClient.postData(
      ApiUrl.resetPassword,
      jsonEncode(body),
    );
    if (response.statusCode == 200) {
      AppRouter.route.goNamed(
        RoutePath.signInScreen,
      );
      toastMessage(
        message: response.body["message"],
      );
    } else {
      ApiChecker.checkApi(response);
    }
    isResetLoading.value = false;
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

        AppRouter.route.pushNamed(RoutePath.otpScreen);

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

  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController businessPhoneController = TextEditingController();
  final TextEditingController businessPasswordController =
      TextEditingController();
  final TextEditingController businessConfirmPasswordController =
      TextEditingController();
  // final TextEditingController businessAddressController =
  //     TextEditingController();
  final TextEditingController businessDescriptionController =
      TextEditingController();
  final TextEditingController businessDeliveryOptionController =
      TextEditingController();
  final TextEditingController businessGenderController =
      TextEditingController();
  TextEditingController docController = TextEditingController();

  Rx<File?> selectedDocument = Rx<File?>(null);
  final RxBool showAllExisting = false.obs;
  final RxList<File> pickedDocuments = <File>[].obs;

  Future<void> pickDocuments() async {
    final picker = ImagePicker();
    final files = await picker.pickMultipleMedia();
    if (files.isNotEmpty) {
      pickedDocuments.assignAll(files.map((e) => File(e.path)));
    }
  }

  RxBool isVendorLoading = false.obs;

  final RxString latitude = ''.obs;
  final RxString longitude = ''.obs;
  final RxString address = 'Pick Your Locations'.obs;

  Future<void> vendorSIgnUp(BuildContext context) async {
    if (!areTrue.value) {
      toastMessage(
          message: "Please make sure your password meets all requirements.");
      return;
    }
    isVendorLoading.value = true;
    refresh();
    if (pickedDocuments.isEmpty) {
      isVendorLoading.value = false;
      refresh();
      toastMessage(message: "Please upload a document before proceeding.");
      return;
    }
    Map<String, dynamic> body = {
      "name": businessNameController.text.trim(),
      "email": businessEmailController.text.trim(),
      "password": businessPasswordController.text.trim(),
      "phone": businessPhoneController.text.trim(),
      "role": "vendor",
      "isSocial": "false",
      "address": address.value,
      "lat": latitude.value,
      "long": longitude.value,
      "description": businessDescriptionController.text.trim(),
      "deliveryOption":
          businessDeliveryOptionController.text.toLowerCase().trim(),
    };

    var response = await ApiClient.postMultipartData(
      ApiUrl.register,
      body,
      multipartBody: pickedDocuments
          .map((file) => MultipartBody("documents", file))
          .toList(),
    );
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      AppRouter.route.pushNamed(
        RoutePath.otpScreen,
        extra: {
          "isVendor": true,
          "email": businessEmailController.text,
        },
      );
      toastMessage(message: responseData["message"]);
    } else if (response.statusCode == 400) {
      toastMessage(message: responseData["error"]);
    } else {
      ApiChecker.checkApi(response);
    }

    isVendorLoading.value = false;
    refresh();
  }

  //>>>>>>>>>>>>>>>>>> Account Active Otp  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isActiveLoading = false.obs;

  Future<void> userAccountActiveOtp() async {
    if (pinCodeController.text.trim().isEmpty) {
      toastMessage(message: "Please enter the activation code.");
      return;
    }

    isActiveLoading.value = true;
    refresh();

    Map<String, String> body = {
      "email": emailController.text.trim(),
      "otp": pinCodeController.text.trim()
    };

    var apiClient = ApiClient();
    // Pass the Map directly so ApiClient.putData can send it as
    // application/x-www-form-urlencoded (expected by server).
    var response = await apiClient.putData(ApiUrl.emailVerify, body);

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
      emailController.clear();
      AppRouter.route.goNamed(RoutePath.signInScreen);
      final msg = respBody != null
          ? (respBody['message'] ?? respBody['msg'] ?? respBody['success'])
              ?.toString()
          : response.statusText;
      toastMessage(message: msg ?? AppStrings.someThing);
    } else if (response.statusCode == 400) {
      final err = respBody != null
          ? (respBody['error'] ?? respBody['message'])?.toString()
          : response.statusText;
      toastMessage(message: err ?? AppStrings.someThing);
    } else {
      ApiChecker.checkApi(response);
      final debugMsg =
          respBody != null ? respBody['message'] ?? respBody : null;
      debugPrint("Error: $debugMsg");
    }
    isActiveLoading.value = false;
    refresh();
  }

  //>>>>>>>>>>>>>>>>>>✅✅Vendor Account Active ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  String vendorActivationCode = "";
  RxBool vendorIsActiveLoading = false.obs;

  Future<void> vendorAccountActiveOtp() async {
    if (vendorActivationCode.isEmpty) {
      toastMessage(message: "Please enter the activation code.");
      return;
    }

    vendorIsActiveLoading.value = true;
    refresh();

    Map<String, String> body = {
      "email": businessEmailController.text.trim(),
      "otp": vendorActivationCode
    };
    // Use PUT and pass Map so it is form-encoded like the user flow.
    var response = await ApiClient().putData(ApiUrl.emailVerify, body);
    vendorIsActiveLoading.value = false;
    refresh();

    if (response.statusCode == 200) {
      businessEmailController.clear();

      AppRouter.route.goNamed(RoutePath.signInScreen);
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
}
