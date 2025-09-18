import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:get/get.dart';


import '../data/local/shared_prefs.dart';

class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) async {
    // Helper to safely get a string message from response.body
    String _extractMessage(dynamic body, String? statusText) {
      try {
        if (body == null) return statusText ?? 'Something went wrong';
        if (body is String) return body;
        if (body is Map<String, dynamic>) {
          final msg = body['message'] ?? body['error'] ?? body['msg'];
          return msg?.toString() ?? (statusText ?? 'Something went wrong');
        }
        return statusText ?? 'Something went wrong';
      } catch (_) {
        return statusText ?? 'Something went wrong';
      }
    }

    final message = _extractMessage(response.body, response.statusText);

    if (response.statusCode == 401) {
      toastMessage(
        message: message,
      );
      await SharePrefsHelper.remove(AppConstants.bearerToken);

      await SharePrefsHelper.setBool(AppConstants.rememberMe, false);
      return;
    } else if (response.statusCode == 403) {
      toastMessage(
        message: message,
      );
      return;
    } else {
      showCustomSnackBar(message, getXSnackBar: getXSnackBar);
    }
  }
}
