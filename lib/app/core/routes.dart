

import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/view/screens/authentication/forget_password/forget_password_screen.dart';
import 'package:barber_time/app/view/screens/authentication/otp/otp_screen.dart';
import 'package:barber_time/app/view/screens/authentication/reset_password/reset_password_screen.dart';
import 'package:barber_time/app/view/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:barber_time/app/view/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/chose_auth/chose_auth_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/chose_role/chose_role_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/get_started/get_started_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_hiring/owner_hiring_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/owner_home_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_message/owner_messaging_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/owner_profile_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/edit_owner_profile.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/personal_info.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/settings.dart';
import 'package:barber_time/app/view/screens/splash/splash_screen.dart';
import 'package:barber_time/app/view/screens/user/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'route_path.dart';

class AppRouter {
  static final GoRouter initRoute = GoRouter(
      initialLocation: RoutePath.signInScreen.addBasePath,
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

        ///=======================ownerHomeScreen =======================
        GoRoute(
          name: RoutePath.ownerHomeScreen,
          path: RoutePath.ownerHomeScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const OwnerHomeScreen(),
            state: state,
          ),
        ),

        ///=======================ownerMessagingScreen  =======================
        GoRoute(
          name: RoutePath.ownerMessagingScreen,
          path: RoutePath.ownerMessagingScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const OwnerMessagingScreen(),
            state: state,
          ),
        ),

        ///=======================ownerHiringScreen  =======================
        GoRoute(
          name: RoutePath.ownerHiringScreen,
          path: RoutePath.ownerHiringScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const OwnerHiringScreen(),
            state: state,
          ),
        ),

        ///=======================ownerProfileScreen  =======================
        GoRoute(
          name: RoutePath.ownerProfileScreen,
          path: RoutePath.ownerProfileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const OwnerProfileScreen(),
            state: state,
          ),
        ),

        ///=======================PersonalInfo  =======================
        GoRoute(
          name: RoutePath.personalInfo,
          path: RoutePath.personalInfo.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const PersonalInfo(),
            state: state,
          ),
        ),

        ///=======================EditOwnerProfile  =======================
        GoRoute(
          name: RoutePath.editOwnerProfile,
          path: RoutePath.editOwnerProfile.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const EditOwnerProfile(),
            state: state,
          ),
        ),

        ///=======================Settings  =======================
        GoRoute(
          name: RoutePath.settings,
          path: RoutePath.settings.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const Settings(),
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
