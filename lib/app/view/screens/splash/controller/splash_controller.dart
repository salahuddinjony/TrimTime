
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{



  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 2), (){
      AppRouter.route.goNamed(RoutePath.choseRoleScreen);
    });
    super.onReady();
  }

}