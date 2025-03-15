import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/view/screens/authentication/forget_password/forget_password_screen.dart';
import 'package:barber_time/app/view/screens/authentication/otp/otp_screen.dart';
import 'package:barber_time/app/view/screens/authentication/owner/owner_shop_details/owner_shop_details.dart';
import 'package:barber_time/app/view/screens/authentication/owner/owner_sign_up/owner_sign_up.dart';
import 'package:barber_time/app/view/screens/authentication/owner/payment_option/payment_option.dart';
import 'package:barber_time/app/view/screens/authentication/owner/subscription/subscription_plan.dart';
import 'package:barber_time/app/view/screens/authentication/owner/unique_qr_code/unique_qr_code.dart';
import 'package:barber_time/app/view/screens/authentication/reset_password/reset_password_screen.dart';
import 'package:barber_time/app/view/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:barber_time/app/view/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:barber_time/app/view/screens/barber/barber_chat/barber_chat.dart';
import 'package:barber_time/app/view/screens/barber/barber_feed/barber_feed.dart';
import 'package:barber_time/app/view/screens/barber/barber_history/barber_history_screen.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/barber_home_screen.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/inner_widgets/job_post_all.dart';
import 'package:barber_time/app/view/screens/notification/notification_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/chose_auth/chose_auth_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/chose_role/chose_role_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/get_started/get_started_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_hiring/owner_hiring_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/owner_home_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_message/chart_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_message/inbox_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/following/following_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/job_post/job_post.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_favorite/my_favorite_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_feed/my_feed.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/owner_profile_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/edit_owner_profile.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/personal_info.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/professional_profile/professional_profile.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/rate/rate_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/change_password/change_password_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/faq/faqs_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/loyalty/loyalty_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/privacy_policy/privacy_policy_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/settings.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/terms/terms_screen.dart';
import 'package:barber_time/app/view/screens/splash/splash_screen.dart';
import 'package:barber_time/app/view/screens/user/home/home_screen.dart';
import 'package:barber_time/app/view/screens/user/que/que_screen.dart';
import 'package:barber_time/app/view/screens/user/saved/saved_screen.dart';
import 'package:barber_time/app/view/screens/user/scanner/scanner_screen.dart';
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
        ///=======================  =======================
        GoRoute(
          name: RoutePath.myFeed,
          path: RoutePath.myFeed.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const MyFeed(),
            state: state,
          ),
        ),    ///=======================  =======================
        GoRoute(
          name: RoutePath.professionalProfile,
          path: RoutePath.professionalProfile.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ProfessionalProfile(),
            state: state,
          ),
        ),    ///=======================  =======================
        GoRoute(
          name: RoutePath.myFavoriteScreen,
          path: RoutePath.myFavoriteScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const MyFavoriteScreen(),
            state: state,
          ),
        ),   ///=======================  =======================
        GoRoute(
          name: RoutePath.followingScreen,
          path: RoutePath.followingScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const FollowingScreen(),
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
            child:  HomeScreen(),
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
            disableAnimation: true,
          ),
        ),

        ///=======================ownerMessagingScreen  =======================

        GoRoute(
          name: RoutePath.chatScreen,
          path: RoutePath.chatScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ChatScreen(),
            state: state,
            disableAnimation: true, // Disable animation for this screen
          ),
        ),

        ///=======================InboxScreen  =======================
        GoRoute(
          name: RoutePath.inboxScreen,
          path: RoutePath.inboxScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const InboxScreen(),
            state: state,
            disableAnimation: true,
          ),
        ),

        ///=======================ownerHiringScreen  =======================
        GoRoute(
          name: RoutePath.ownerHiringScreen,
          path: RoutePath.ownerHiringScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const OwnerHiringScreen(),
            state: state,
            disableAnimation: true,
          ),
        ),

        ///=======================ownerProfileScreen  =======================
        GoRoute(
          name: RoutePath.profileScreen,
          path: RoutePath.profileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ProfileScreen(),
            state: state,
            disableAnimation: true,
          ),
        ),
        //TODO:Barber
        ///=======================  =======================
        GoRoute(
          name: RoutePath.barberHomeScreen,
          path: RoutePath.barberHomeScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  BarberHomeScreen(),
            state: state,
            disableAnimation: true,
          ),
        ), ///=======================  =======================
        GoRoute(
          name: RoutePath.notificationScreen,
          path: RoutePath.notificationScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  const NotificationScreen(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.barberHistoryScreen,
          path: RoutePath.barberHistoryScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const BarberHistoryScreen(),
            state: state,
            disableAnimation: true,
          ),
        ),



        ///=======================  =======================
        GoRoute(
          name: RoutePath.barberChat,
          path: RoutePath.barberChat.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const BarberChat(),
            state: state,
            disableAnimation: true,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.barberFeed,
          path: RoutePath.barberFeed.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const BarberFeed(),
            state: state,
            disableAnimation: true,
          ),
        ),

    ///=======================  =======================
        GoRoute(
          name: RoutePath.jobPostAll,
          path: RoutePath.jobPostAll.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  JobPostAll(),
            state: state,
            disableAnimation: true,
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

        ///=======================ChangePasswordScreen  =======================
        GoRoute(
          name: RoutePath.changePasswordScreen,
          path: RoutePath.changePasswordScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ChangePasswordScreen(),
            state: state,
          ),
        ),

        ///=======================FaqsScreen  =======================
        GoRoute(
          name: RoutePath.faqsScreen,
          path: RoutePath.faqsScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: FaqsScreen(),
            state: state,
          ),
        ),

        ///=======================PrivacyPolicyScreen  =======================
        GoRoute(
          name: RoutePath.privacyPolicyScreen,
          path: RoutePath.privacyPolicyScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const PrivacyPolicyScreen(),
            state: state,
          ),
        ),

        ///=======================TermsScreen  =======================
        GoRoute(
          name: RoutePath.termsScreen,
          path: RoutePath.termsScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const TermsScreen(),
            state: state,
          ),
        ),

        ///=======================LoyaltyScreen  =======================
        GoRoute(
          name: RoutePath.loyaltyScreen,
          path: RoutePath.loyaltyScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const LoyaltyScreen(),
            state: state,
          ),
        ),

        ///=======================Job Post  =======================
        GoRoute(
          name: RoutePath.jobPost,
          path: RoutePath.jobPost.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const JobPost(),
            state: state,
          ),
        ),

        ///=======================Job Post  =======================
        GoRoute(
          name: RoutePath.ownerSignUp,
          path: RoutePath.ownerSignUp.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: OwnerSignUp(),
            state: state,
          ),
        ),

        ///=======================OwnerShopDetails =======================
        GoRoute(
          name: RoutePath.ownerShopDetails,
          path: RoutePath.ownerShopDetails.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: OwnerShopDetails(),
            state: state,
          ),
        ),

        ///=======================SubscriptionPlan =======================
        GoRoute(
          name: RoutePath.subscriptionPlan,
          path: RoutePath.subscriptionPlan.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: SubscriptionPlan(),
            state: state,
          ),
        ),

        ///=======================PaymentOption =======================
        GoRoute(
          name: RoutePath.paymentOption,
          path: RoutePath.paymentOption.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: PaymentOption(),
            state: state,
          ),
        ),

        ///=======================UniqueQrCode =======================
        GoRoute(
          name: RoutePath.uniqueQrCode,
          path: RoutePath.uniqueQrCode.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: UniqueQrCode(),
            state: state,
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.queScreen,
          path: RoutePath.queScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const QueScreen(),
            state: state,
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.scannerScreen,
          path: RoutePath.scannerScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ScannerScreen(),
            state: state,
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.savedScreen,
          path: RoutePath.savedScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const SavedScreen(),
            state: state,
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.rateScreen,
          path: RoutePath.rateScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const RateScreen(),
            state: state,
          ),
        ),
      ]);

  static CustomTransitionPage _buildPageWithAnimation(
      {required Widget child,
      required GoRouterState state,
      bool disableAnimation = false}) {
    if (disableAnimation) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionDuration: Duration.zero, // Disable animation
        transitionsBuilder: (_, __, ___, child) => child, // No transition
      );
    } else {
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
  }

  static GoRouter get route => initRoute;
}
