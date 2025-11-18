import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/utils/app_constants.dart';

mixin UserInfoFromStorage {
  String? userId;
  String? userRole;
  String? userName;

  Future<void> loadUserInfo() async {
    userId = await SharePrefsHelper.getString(AppConstants.userId);
    userRole = await SharePrefsHelper.getString(AppConstants.role);
    userName = await SharePrefsHelper.getString(AppConstants.qrCode as String);
    print("User info loaded from storage");
  }
}