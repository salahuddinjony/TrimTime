

import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/global/helper/extension.dart';
import 'package:barber_time/app/view/splash_screen.dart';
import 'package:go_router/go_router.dart';



class AppRouter {
  static final GoRouter initRoute = GoRouter(
      initialLocation: RoutePath.splashScreen.addBasePath,
      // navigatorKey: Get.key,
      debugLogDiagnostics: true,
      routes: [
        ///======================= splash Route =======================
        // GoRoute(
        //   name: RoutePath.splashScreen,
        //   path: RoutePath.splashScreen.addBasePath,
        //   builder: (context, state) => const SplashScreen(),
        //   redirect: (context, state) {
        //     // Future.delayed(const Duration(seconds: 1), () async{
        //     //   bool? isRememberMe = await SharePrefsHelper.getBool(AppConstants.isRememberMe);
        //     //   if (isRememberMe == true ) {
        //     //     AppRouter.route.replaceNamed(RoutePath.homeScreen);
        //     //   }   else {
        //     //     AppRouter.route.replaceNamed(RoutePath.signInScreen);
        //     //   }
        //     // });
        //     return null;
        //   },
        // ),

        ///=======================DartScreen =======================
        GoRoute(
          name: RoutePath.splashScreen,
          path: RoutePath.splashScreen.addBasePath,
          builder: (context, state) =>  const SplashScreen(),
        ),


      ]);

  static GoRouter get route => initRoute;
}



