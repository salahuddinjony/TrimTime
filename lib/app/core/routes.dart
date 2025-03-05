import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/global/helper/extension.dart';
import 'package:barber_time/app/view/screens/authentication/forget_password/forget_password_screen.dart';
import 'package:barber_time/app/view/screens/authentication/otp/otp_screen.dart';
import 'package:barber_time/app/view/screens/authentication/reset_password/reset_password_screen.dart';
import 'package:barber_time/app/view/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:barber_time/app/view/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/chose_auth/chose_auth_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/chose_role/chose_role_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/get_started/get_started_screen.dart';
import 'package:barber_time/app/view/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter initRoute = GoRouter(
    initialLocation: RoutePath.splashScreen.addBasePath,
    debugLogDiagnostics: true,
    routes: [
      ///======================= Splash Route =======================
      GoRoute(
        name: RoutePath.splashScreen,
        path: RoutePath.splashScreen.addBasePath,
        builder: (context, state) => const SplashScreen(),
        redirect: (context, state) {
          Future.delayed(const Duration(seconds: 2), () async {
            AppRouter.route.replaceNamed(RoutePath.choseRoleScreen);
          });
          return null;
        },
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SplashScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn));
              var opacityAnimation = animation.drive(tween);
              return FadeTransition(opacity: opacityAnimation, child: child);
            },
          );
        },
      ),

      ///======================= Chose Role Route ====================
      GoRoute(
        name: RoutePath.choseRoleScreen,
        path: RoutePath.choseRoleScreen.addBasePath,
        builder: (context, state) => const ChoseRoleScreen(),
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ChoseRoleScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var slideTween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
              var slideAnimation = animation.drive(slideTween);
              return SlideTransition(position: slideAnimation, child: child);
            },
          );
        },
      ),

      ///======================= Chose Auth Route ====================
      GoRoute(
        name: RoutePath.choseAuthScreen,
        path: RoutePath.choseAuthScreen.addBasePath,
        builder: (context, state) => const ChoseAuthScreen(),
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ChoseAuthScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var slideTween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
              var slideAnimation = animation.drive(slideTween);
              return SlideTransition(position: slideAnimation, child: child);
            },
          );
        },
      ),

      ///======================= Get Started ====================
      GoRoute(
        name: RoutePath.getStartedScreen,
        path: RoutePath.getStartedScreen.addBasePath,
        builder: (context, state) => const GetStartedScreen(),
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const GetStartedScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var slideTween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
              var slideAnimation = animation.drive(slideTween);
              return SlideTransition(position: slideAnimation, child: child);
            },
          );
        },
      ),

      ///======================= Sing In ====================
      GoRoute(
        name: RoutePath.signInScreen,
        path: RoutePath.signInScreen.addBasePath,
        builder: (context, state) =>  SignInScreen(),
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child:  SignInScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var slideTween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
              var slideAnimation = animation.drive(slideTween);
              return SlideTransition(position: slideAnimation, child: child);
            },
          );
        },
      ),

      ///======================= Sing Up ====================
      GoRoute(
        name: RoutePath.signUpScreen,
        path: RoutePath.signUpScreen.addBasePath,
        builder: (context, state) =>  SignUpScreen(),
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child:  SignUpScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var slideTween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
              var slideAnimation = animation.drive(slideTween);
              return SlideTransition(position: slideAnimation, child: child);
            },
          );
        },
      ),

      ///======================= OtpScreen ====================
      GoRoute(
        name: RoutePath.otpScreen,
        path: RoutePath.otpScreen.addBasePath,
        builder: (context, state) =>  OtpScreen(),
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child:  OtpScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var slideTween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
              var slideAnimation = animation.drive(slideTween);
              return SlideTransition(position: slideAnimation, child: child);
            },
          );
        },
      ),

      ///======================= OtpScreen ====================
      GoRoute(
        name: RoutePath.resetPasswordScreen,
        path: RoutePath.resetPasswordScreen.addBasePath,
        builder: (context, state) =>  ResetPasswordScreen(),
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child:  ResetPasswordScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var slideTween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
              var slideAnimation = animation.drive(slideTween);
              return SlideTransition(position: slideAnimation, child: child);
            },
          );
        },
      ),

      ///======================= ForgetPasswordScreen ====================
      GoRoute(
        name: RoutePath.forgetPasswordScreen,
        path: RoutePath.forgetPasswordScreen.addBasePath,
        builder: (context, state) =>   ForgetPasswordScreen(),
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child:   ForgetPasswordScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var slideTween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
              var slideAnimation = animation.drive(slideTween);
              return SlideTransition(position: slideAnimation, child: child);
            },
          );
        },
      ),
    ],
  );

  static GoRouter get route => initRoute;
}
