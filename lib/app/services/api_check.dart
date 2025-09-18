import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:get/get.dart';


import '../data/local/shared_prefs.dart';

class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) async {
    if (response.statusCode == 401) {
      toastMessage(
        message: response.body["message"],
      );
      await SharePrefsHelper.remove(AppConstants.bearerToken);

      await SharePrefsHelper.setBool(AppConstants.rememberMe, false);
      // AppRouter.route.goNamed(
      //   RoutePath.signInScreen,
      // );
    } else if (response.statusCode == 403) {
      toastMessage(
        message: response.body["message"],
      );
    } else {
      showCustomSnackBar(response.statusText, getXSnackBar: getXSnackBar);
    }
  }
}
