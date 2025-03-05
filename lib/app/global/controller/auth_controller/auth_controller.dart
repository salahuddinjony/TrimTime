import 'package:barber_time/app/global/helper/local_db/local_db.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final pinCodeController = TextEditingController();

  RxBool isRemember = false.obs;

  toggleRemember() {
    isRemember.value = !isRemember.value;
    debugPrint("Remember me==============>>>>>>>>>$isRemember");
    refresh();
    SharePrefsHelper.setBool(AppConstants.isRememberMe, isRemember.value);
  }
}