import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    checkLogin();
  }

  void checkLogin() async {
    // Wait a bit to show splash
    await Future.delayed(const Duration(seconds: 1));

    // Decide the initial route
    final route = await AuthController.getInitialRoute();

    // Retrieve saved role string and convert to UserRole enum when available
    final savedRole = await AuthController.getSavedRole();
    UserRole? roleEnum;
    if (savedRole != null && savedRole.isNotEmpty) {
      roleEnum = getRoleFromString(savedRole);
    }

    // Navigate and pass the role as 'extra' so downstream screens receive it
    if (roleEnum != null) {
      AppRouter.route.goNamed(route, extra: roleEnum);
    } else {
      AppRouter.route.goNamed(route);
    }
  }
}
