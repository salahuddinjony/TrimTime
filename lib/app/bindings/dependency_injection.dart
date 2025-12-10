import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/global/controller/bottom_nav_controller/bottom_nav_color.dart';
import 'package:barber_time/app/global/controller/general_controller/general_controller.dart';
import 'package:barber_time/app/global/controller/payment_controller/payment_controller.dart';
import 'package:barber_time/app/view/screens/barber/barber_feed/controller/barber_feed_controller.dart';
import 'package:barber_time/app/view/screens/barber/barber_history/controller/history_controller.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/barber_home_controller.dart';
import 'package:barber_time/app/view/screens/common_screen/map/my_map/controller/map_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_hiring/controller/owner_hiring_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/controller/barber_owner_home_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/job_post/controller/barber_owner_job_post_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/info_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/loyality/controller/loyality_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/que_controller.dart';
import 'package:barber_time/app/view/screens/splash/controller/splash_controller.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:barber_time/app/view/screens/user/saved/controller/saved_controller.dart';
import 'package:get/get.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => SplashController(), fenix: true);
    Get.lazyPut(() => InfoController(), fenix: true);
    Get.lazyPut(() => OwnerProfileController(), fenix: true);
    Get.lazyPut(() => PaymentController(), fenix: true);
    Get.lazyPut(() => GeneralController(), fenix: true);
    Get.lazyPut(() => BarberHomeController(), fenix: true);
    Get.lazyPut(() => OwnerHiringController(), fenix: true);
    Get.lazyPut(() => BottomNavbarController(), fenix: true);
    Get.lazyPut(() => UserHomeController(), fenix: true);
    // Get.lazyPut(() => MessagingController(), fenix: true);
    Get.lazyPut(() => BarberFeedController(), fenix: true);
    Get.lazyPut(() => OwnerProfileController(), fenix: true);
    Get.lazyPut(() => HistoryController(), fenix: true);
    Get.lazyPut(() => BarberOwnerJobPostController(), fenix: true);
    Get.lazyPut(() => BarberOwnerHomeController(), fenix: true);
    Get.lazyPut(() => QueController(), fenix: true);
    Get.lazyPut(() => LoyalityController(), fenix: true);
    Get.lazyPut(() => SavedController(), fenix: true);
    Get.lazyPut(() => MapController(), fenix: true);
  }
}
