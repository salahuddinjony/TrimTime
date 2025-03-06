
import 'package:barber_time/app/core/route_path.dart';

extension BasePathExtensions on String {
  String get addBasePath {
    return RoutePath.basePath + this;
  }
}