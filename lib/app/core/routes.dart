// import 'package:barber_time/app/core/route_path.dart';
// import 'package:barber_time/app/global/helper/extension.dart';
// import 'package:barber_time/app/view/screens/authentication/forget_password/forget_password_screen.dart';
// import 'package:barber_time/app/view/screens/authentication/otp/otp_screen.dart';
// import 'package:barber_time/app/view/screens/authentication/reset_password/reset_password_screen.dart';
// import 'package:barber_time/app/view/screens/authentication/sign_in/sign_in_screen.dart';
// import 'package:barber_time/app/view/screens/authentication/sign_up/sign_up_screen.dart';
// import 'package:barber_time/app/view/screens/onboarding/chose_auth/chose_auth_screen.dart';
// import 'package:barber_time/app/view/screens/onboarding/chose_role/chose_role_screen.dart';
// import 'package:barber_time/app/view/screens/onboarding/get_started/get_started_screen.dart';
// import 'package:barber_time/app/view/screens/splash/splash_screen.dart';
// import 'package:barber_time/app/view/screens/user/home/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// class AppRouter {
//   static final GoRouter initRoute = GoRouter(
//     initialLocation: RoutePath.splashScreen.addBasePath,
//     debugLogDiagnostics: true,
//     routes: [
//       ///======================= Splash Route =======================
//       GoRoute(
//         name: RoutePath.splashScreen,
//         path: RoutePath.splashScreen.addBasePath,
//         builder: (context, state) => const SplashScreen(),
//         redirect: (context, state) {
//           Future.delayed(const Duration(seconds: 2), () async {
//             AppRouter.route.replaceNamed(RoutePath.choseRoleScreen);
//           });
//           return null;
//         },
//         pageBuilder: (context, state) {
//           return CustomTransitionPage(
//             key: state.pageKey,
//             child: const SplashScreen(),
//             transitionsBuilder: (context, animation, secondaryAnimation, child) {
//               var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn));
//               var opacityAnimation = animation.drive(tween);
//               return FadeTransition(opacity: opacityAnimation, child: child);
//             },
//           );
//         },
//       ),
//
//       ///======================= Chose Role Route ====================
//       GoRoute(
//         name: RoutePath.choseRoleScreen,
//         path: RoutePath.choseRoleScreen.addBasePath,
//         builder: (context, state) => const ChoseRoleScreen(),
//         pageBuilder: (context, state) {
//           return CustomTransitionPage(
//             key: state.pageKey,
//             child: const ChoseRoleScreen(),
//             transitionsBuilder: (context, animation, secondaryAnimation, child) {
//               var slideTween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
//               var slideAnimation = animation.drive(slideTween);
//               return SlideTransition(position: slideAnimation, child: child);
//             },
//           );
//         },
//       ),
//
//       ///======================= Chose Auth Route ====================
//       GoRoute(
//         name: RoutePath.choseAuthScreen,
//         path: RoutePath.choseAuthScreen.addBasePath,
//         builder: (context, state) => const ChoseAuthScreen(),
//         pageBuilder: (context, state) {
//           return CustomTransitionPage(
//             key: state.pageKey,
//             child: const ChoseAuthScreen(),
//             transitionsBuilder: (context, animation, secondaryAnimation, child) {
//               var slideTween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
//               var slideAnimation = animation.drive(slideTween);
//               return SlideTransition(position: slideAnimation, child: child);
//             },
//           );
//         },
//       ),
//
//       ///======================= Get Started ====================
//       GoRoute(
//         name: RoutePath.getStartedScreen,
//         path: RoutePath.getStartedScreen.addBasePath,
//         builder: (context, state) => const GetStartedScreen(),
//         pageBuilder: (context, state) {
//           return CustomTransitionPage(
//             key: state.pageKey,
//             child: const GetStartedScreen(),
//             transitionsBuilder: (context, animation, secondaryAnimation, child) {
//               var slideTween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
//               var slideAnimation = animation.drive(slideTween);
//               return SlideTransition(position: slideAnimation, child: child);
//             },
//           );
//         },
//       ),
//
//       ///======================= Sing In ====================
//       GoRoute(
//         name: RoutePath.signInScreen,
//         path: RoutePath.signInScreen.addBasePath,
//         builder: (context, state) =>  SignInScreen(),
//
//       ),
//
//       ///======================= Sing Up ====================
//       GoRoute(
//         name: RoutePath.signUpScreen,
//         path: RoutePath.signUpScreen.addBasePath,
//         builder: (context, state) =>  SignUpScreen(),
//
//       ),
//
//       ///======================= OtpScreen ====================
//       GoRoute(
//         name: RoutePath.otpScreen,
//         path: RoutePath.otpScreen.addBasePath,
//         builder: (context, state) =>  OtpScreen(),
//
//       ),
//
//       ///======================= resetPasswordScreen ====================
//       GoRoute(
//         name: RoutePath.resetPasswordScreen,
//         path: RoutePath.resetPasswordScreen.addBasePath,
//         builder: (context, state) =>  ResetPasswordScreen(),
//
//       ),
//
//       ///======================= ForgetPasswordScreen ====================
//       GoRoute(
//         name: RoutePath.forgetPasswordScreen,
//         path: RoutePath.forgetPasswordScreen.addBasePath,
//         builder: (context, state) =>   ForgetPasswordScreen(),
//
//       ),
//
//       ///======================= ForgetPasswordScreen ====================
//       GoRoute(
//         name: RoutePath.homeScreen,
//         path: RoutePath.homeScreen.addBasePath,
//         builder: (context, state) =>   const HomeScreen(),
//       ),
//     ],
//   );
//
//   static GoRouter get route => initRoute;
// }

import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/view/screens/authentication/forget_password/forget_password_screen.dart';
import 'package:barber_time/app/view/screens/authentication/otp/otp_screen.dart';
import 'package:barber_time/app/view/screens/authentication/reset_password/reset_password_screen.dart';
import 'package:barber_time/app/view/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:barber_time/app/view/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/chose_auth/chose_auth_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/chose_role/chose_role_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/get_started/get_started_screen.dart';
import 'package:barber_time/app/view/screens/splash/splash_screen.dart';
import 'package:barber_time/app/view/screens/user/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'route_path.dart';

class AppRouter {
  static final GoRouter initRoute = GoRouter(
      initialLocation: RoutePath.splashScreen.addBasePath,
      debugLogDiagnostics: true,
      navigatorKey: GlobalKey<NavigatorState>(),
      routes: [
        ///======================= Initial Route =======================
        GoRoute(
          name: RoutePath.splashScreen,
          path: RoutePath.splashScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: SplashScreen(),
            state: state,
          ),
        ),



        ///======================= choseRoleScreen Route =======================

        GoRoute(
          name: RoutePath.choseRoleScreen,
          path: RoutePath.choseRoleScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ChoseRoleScreen(),
            state: state,
          ),
        ),

        ///======================= choseAuthScreen Route =======================
        GoRoute(
          name: RoutePath.choseAuthScreen,
          path: RoutePath.choseAuthScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ChoseAuthScreen(),
            state: state,
          ),
        ),

        ///======================= GetStartedScreen Route =======================
        GoRoute(
          name: RoutePath.getStartedScreen,
          path: RoutePath.getStartedScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const GetStartedScreen(),
            state: state,
          ),
        ),
        ///======================= signInScreen Route =======================
        GoRoute(
          name: RoutePath.signInScreen,
          path: RoutePath.signInScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: SignInScreen(),
            state: state,
          ),
        ),

        ///======================= SignUpScreen Route =======================
        GoRoute(
          name: RoutePath.signUpScreen,
          path: RoutePath.signUpScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: SignUpScreen(),
            state: state,
          ),
        ),

        ///======================= ForgetPasswordScreen Route =======================
        GoRoute(
          name: RoutePath.forgetPasswordScreen,
          path: RoutePath.forgetPasswordScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: ForgetPasswordScreen(),
            state: state,
          ),
        ),

        ///======================= OtpScreen Route =======================
        GoRoute(
          name: RoutePath.otpScreen,
          path: RoutePath.otpScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: OtpScreen(),
            state: state,
          ),
        ),

        ///======================= OtpScreen Route =======================
        GoRoute(
          name: RoutePath.resetPasswordScreen,
          path: RoutePath.resetPasswordScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: ResetPasswordScreen(),
            state: state,
          ),
        ),

        ///======================= OtpScreen Route =======================
        GoRoute(
          name: RoutePath.homeScreen,
          path: RoutePath.homeScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const HomeScreen(),
            state: state,
          ),
        ),

      ]);

  static CustomTransitionPage _buildPageWithAnimation(
      {required Widget child, required GoRouterState state}) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static GoRouter get route => initRoute;
}
