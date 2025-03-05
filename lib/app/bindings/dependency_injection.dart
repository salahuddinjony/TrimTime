
import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:get/get.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);


  }
}