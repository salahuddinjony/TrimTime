import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_barber_job_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
class HistoryController extends GetxController with BarberJobHistoryMixin{
  @override
  void onInit() {
    getAllJobHistory();
    super.onInit();
    debugPrint("HistoryController initialized");
  }
}