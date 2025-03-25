import 'package:barber_time/app/global/helper/device_utils/device_utils.dart';
import 'package:flutter/material.dart';

import 'my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DeviceUtils.lockDevicePortrait();
  runApp(const MyApp());

}







