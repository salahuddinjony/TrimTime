import 'package:barber_time/app/global/helper/device_utils/device_utils.dart';
import 'package:flutter/material.dart';

import 'my_app.dart';
import 'app/data/local/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharePrefsHelper.init();
  DeviceUtils.lockDevicePortrait();
  runApp(const MyApp());
}








