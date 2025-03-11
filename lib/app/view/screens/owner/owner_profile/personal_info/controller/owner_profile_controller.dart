import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OwnerProfileController extends GetxController{
  var selectedValue = ''.obs;

  void updateSelection(String value, TextEditingController controller) {
    selectedValue.value = value;
    controller.text = value;
  }



}