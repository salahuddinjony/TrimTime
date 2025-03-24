
import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/global/controller/bottom_nav_controller/bottom_nav_color.dart';
import 'package:barber_time/app/global/controller/general_controller/general_controller.dart';
import 'package:barber_time/app/global/controller/payment_controller/payment_controller.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/barber_home_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_hiring/controller/owner_hiring_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_message/controller/messaging_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/info_controller.dart';
import 'package:barber_time/app/view/screens/splash/controller/splash_controller.dart';
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
    // Get.lazyPut(() => MessagingController(), fenix: true);


  }
}