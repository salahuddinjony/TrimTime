import 'package:get/get.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';

class BottomNavbarController extends GetxController {
  RxInt bottomNavIndex = 0.obs;
  Rx<UserRole> userRole = UserRole.user.obs;  // Default role is user

  void setBottomNavIndex(int index) {
    bottomNavIndex.value = index;
  }

  void setUserRole(UserRole role) {
    userRole.value = role;
  }
}
