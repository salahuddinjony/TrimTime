import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_barber_apply_job.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_barber_home_screen_data.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_barber_job_history.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_booking_management.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_feeds_management.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_schedule_management.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_seloon_mng/mixin_selon_management.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BarberHomeController extends GetxController
    with
        BarberJobHistoryMixin,
        BarberHomeScreenDataMixin,
        MixinBarberApplyJob,
        MixinFeedsManagement,
        MixinSelonManagement,
        ScheduleManagementMixin,
        BookingManagementMixin {
  var selectedFilter = "Nearby job".obs; // Now it's reactive

  @override
  void onInit() async {
    super.onInit();
    final String role = await SharePrefsHelper.getString(AppConstants.role);

    if (role != "CUSTOMER") {
      initializeOninitFunctions();
    }
    debugPrint("Barber Home Controller initialized");
    getHomeFeeds();
  }

  void initializeOninitFunctions() {
    getAllJobHistory();
    getAllJobPost();
    fetchScheduleData(useDay: false); // Fetch all schedule data
  }
}
