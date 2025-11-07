import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_barber_job_history.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_feeds_management.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_schedule_management.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_selon_management.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/controller/mixin/mixin_job_app_manage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarberOwnerHomeController extends GetxController
    with
        MixinFeedsManagement,
        MixinSelonManagement,
        ScheduleManagementMixin,
        BarberJobHistoryMixin,
        JobApplicationManageMixin {
  @override
  void onInit() {
    super.onInit();
    getJobApplications();
    fetchScheduleData(useDay: false); // Fetch all schedule data
    getHomeFeeds();

    debugPrint("Barber Owner Home Controller initialized");
  }

  @override
  void onClose() {
    debugPrint("Barber Owner Home Controller disposed");
    super.onClose();
  }
}
