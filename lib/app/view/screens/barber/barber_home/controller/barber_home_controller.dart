import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_barber_apply_job.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_barber_home_screen_data.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_barber_job_history.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BarberHomeController extends GetxController with BarberJobHistoryMixin, BarberHomeScreenDataMixin, MixinBarberApplyJob{
  var selectedFilter = "Nearby job".obs; // Now it's reactive



  @override
  void onInit() {
    super.onInit();
    getAllJobHistory();
    debugPrint  ("Barber Home Controller initialized");
    getAllJobPost();
  }
}