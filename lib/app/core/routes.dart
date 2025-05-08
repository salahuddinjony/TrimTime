import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/enums/transition_type.dart';
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
import 'package:barber_time/app/view/screens/barber/barber_home/inner_widgets/feed_all.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/inner_widgets/job_post_all.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/schedule_screen/schedule_screen.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/visit_shop/visit_shop.dart';
import 'package:barber_time/app/view/screens/barber/barber_que_screen/barber_que_screen.dart';
import 'package:barber_time/app/view/screens/common_screen/map/map_view_screen.dart';
import 'package:barber_time/app/view/screens/common_screen/my_loyality/my_loyality.dart';
import 'package:barber_time/app/view/screens/common_screen/my_loyality/my_loyality_rewards.dart';
import 'package:barber_time/app/view/screens/common_screen/notification/notification_screen.dart';
import 'package:barber_time/app/view/screens/common_screen/search_saloon/search_saloon_screen.dart';
import 'package:barber_time/app/view/screens/common_screen/shop_profile/shop_profile_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/chose_auth/chose_auth_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/chose_role/chose_role_screen.dart';
import 'package:barber_time/app/view/screens/onboarding/get_started/get_started_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_hiring/owner_hiring_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/inner_widgets/booking_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/inner_widgets/recent_request_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/owner_home_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_message/chart_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_message/inbox_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/barber/barber.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/business_profile/business_profile.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/business_profile/business_profile_edit/business_profile_edit.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/following/following_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/job_post/create_job_post.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/job_post/job_post.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_favorite/my_favorite_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_feed/my_feed.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/owner_profile_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/edit_owner_profile.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/personal_info.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/professional_profile/edit_professional_profile/edit_professional_profile.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/professional_profile/professional_profile.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/rate/rate_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/change_password/change_password_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/faq/faqs_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/loyality/loyality_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/privacy_policy/privacy_policy_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/settings.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/terms/terms_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/owner_que.dart';
import 'package:barber_time/app/view/screens/splash/splash_screen.dart';
import 'package:barber_time/app/view/screens/user/berber_time/berber_times.dart';
import 'package:barber_time/app/view/screens/user/berber_time/que/que_screen.dart';
import 'package:barber_time/app/view/screens/user/bookings/booking_details/booking_details_screen.dart';
import 'package:barber_time/app/view/screens/user/bookings/booking_screen.dart';
import 'package:barber_time/app/view/screens/user/bookings/reschedule_screen/reschedule_screen.dart';
import 'package:barber_time/app/view/screens/user/home/home_screen.dart';
import 'package:barber_time/app/view/screens/user/home/inner_screens/near_you_shop_screen.dart';
import 'package:barber_time/app/view/screens/user/home/inner_screens/tips_screen.dart';
import 'package:barber_time/app/view/screens/user/saved/saved_screen.dart';
import 'package:barber_time/app/view/screens/user/scanner/scanner_screen.dart';
import 'package:barber_time/app/view/screens/user/user_bokking/choose_barber_screen.dart';
import 'package:barber_time/app/view/screens/user/user_bokking/summery_screen.dart';
import 'package:barber_time/app/view/screens/user/user_bokking/user_booking_screen.dart';
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
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.professionalProfile,
          path: RoutePath.professionalProfile.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ProfessionalProfile(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.myFavoriteScreen,
          path: RoutePath.myFavoriteScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const MyFavoriteScreen(),
            state: state,
          ),
        ),

        ///=======================  =======================
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
            child: HomeScreen(),
            state: state,
            disableAnimation: true,
          ),
        ),

        ///=======================ownerHomeScreen =======================
        GoRoute(
          name: RoutePath.ownerHomeScreen,
          path: RoutePath.ownerHomeScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: OwnerHomeScreen(),
            state: state,
            // disableAnimation: true,
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.recentRequestScreen,
          path: RoutePath.recentRequestScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const RecentRequestScreen(),
            state: state,
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
            child: OwnerHiringScreen(),
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

        ///=======================  =======================
        GoRoute(
          name: RoutePath.berberTimes,
          path: RoutePath.berberTimes.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const BerberTimes(), state: state, disableAnimation: true),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.bookingScreen,
          path: RoutePath.bookingScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const BookingScreen(),
              state: state,
              disableAnimation: true),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.barberQueScreen,
          path: RoutePath.barberQueScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const BarberQueScreen(),
            state: state,
          ),
        ),

        ///=======================CreateJobPost  =======================
        GoRoute(
          name: RoutePath.createJobPost,
          path: RoutePath.createJobPost.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const CreateJobPost(),
            state: state,
          ),
        ),

        ///=======================CreateJobPost  =======================
        GoRoute(
          name: RoutePath.nearYouShopScreen,
          path: RoutePath.nearYouShopScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const NearYouShopScreen(),
            state: state,
          ),
        ),

        ///=======================HiringBarber  =======================
        GoRoute(
          name: RoutePath.hiringBarber,
          path: RoutePath.hiringBarber.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const HiringBarber(),
            state: state,
          ),
        ),

        ///=======================VisitShop  =======================
        GoRoute(
          name: RoutePath.visitShop,
          path: RoutePath.visitShop.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const VisitShop(),
            state: state,
            transitionType: TransitionType
                .detailsScreen,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.searchSaloonScreen,
          path: RoutePath.searchSaloonScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const SearchSaloonScreen(),
            state: state,
          ),
        ),

        ///=======================VisitShop  =======================
        GoRoute(
          name: RoutePath.businessProfile,
          path: RoutePath.businessProfile.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const BusinessProfile(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.businessProfileEdit,
          path: RoutePath.businessProfileEdit.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const BusinessProfileEdit(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.bookingDetailsScreen,
          path: RoutePath.bookingDetailsScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const BookingDetailsScreen(),
              state: state,
              transitionType: TransitionType.detailsScreen),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.tipsScreen,
          path: RoutePath.tipsScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const TipsScreen(),
            state: state,
            transitionType: TransitionType
                .detailsScreen,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.mapViewScreen,
          path: RoutePath.mapViewScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: MapViewScreen(),
            state: state,
          ),
        ),

        ///=======================editProfessionalProfile  =======================
        GoRoute(
          name: RoutePath.editProfessionalProfile,
          path: RoutePath.editProfessionalProfile.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const EditProfessionalProfile(),
            state: state,
          ),
        ),
        //TODO:Barber
        ///=======================  =======================
        GoRoute(
          name: RoutePath.barberHomeScreen,
          path: RoutePath.barberHomeScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: BarberHomeScreen(),
            state: state,
            disableAnimation: true,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.notificationScreen,
          path: RoutePath.notificationScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const NotificationScreen(),
            state: state,
            transitionType: TransitionType
                .detailsScreen,
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
            child: JobPostAll(),
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

        ///=======================PersonalInfo  =======================
        GoRoute(
          name: RoutePath.feedAll,
          path: RoutePath.feedAll.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const FeedAll(),
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
            child: const OwnerShopDetails(),
            state: state,
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.scheduleScreen,
          path: RoutePath.scheduleScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ScheduleScreen(),
            state: state,
            transitionType: TransitionType
                .detailsScreen,
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
            child: const UniqueQrCode(),
            state: state,
            transitionType: TransitionType
                .detailsScreen,
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.queScreen,
          path: RoutePath.queScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const QueScreen(),
            state: state,
            disableAnimation: true,
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.myLoyality,
          path: RoutePath.myLoyality.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const MyLoyality(),
            state: state,
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.ownerQue,
          path: RoutePath.ownerQue.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const OwnerQue(), state: state, disableAnimation: true),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.loyalityScreen,
          path: RoutePath.loyalityScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const LoyalityScreen(),
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
            disableAnimation: true,
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.savedScreen,
          path: RoutePath.savedScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const SavedScreen(),
            state: state,
            disableAnimation: true,
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

        ///======================= =======================
        GoRoute(
          name: RoutePath.myLoyalityRewards,
          path: RoutePath.myLoyalityRewards.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const MyLoyalityRewards(),
            state: state,
            transitionType: TransitionType
                .detailsScreen,
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.shopProfileScreen,
          path: RoutePath.shopProfileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ShopProfileScreen(),
            state: state,
            transitionType: TransitionType
                .detailsScreen, // Custom transition type for detail screens
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.rescheduleScreen,
          path: RoutePath.rescheduleScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const RescheduleScreen(),
            state: state,
            transitionType: TransitionType
                .detailsScreen, // Custom transition type for detail screens
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.userBookingScreen,
          path: RoutePath.userBookingScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const UserBookingScreen(),
            state: state,
            transitionType: TransitionType
                .detailsScreen, // Custom transition type for detail screens
          ),
        ),

        ///=======================ownerRequestBooking =======================
        GoRoute(
          name: RoutePath.ownerRequestBooking,
          path: RoutePath.ownerRequestBooking.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const OwnerRequestBooking(),
            state: state,
          ),
        ),


        ///======================= =======================
        GoRoute(
          name: RoutePath.chooseBarberScreen,
          path: RoutePath. chooseBarberScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ChooseBarberScreen(),
            state: state,
            // transitionType: TransitionType
            //     .detailsScreen,
          ),
        ),
        ///======================= =======================
        GoRoute(
          name: RoutePath.summeryScreen,
          path: RoutePath. summeryScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const SummeryScreen(),
            state: state,
            // transitionType: TransitionType
            //     .detailsScreen, // Custom transition type for detail screens
          ),
        ),
      ]);

  static CustomTransitionPage _buildPageWithAnimation({
    required Widget child,
    required GoRouterState state,
    bool disableAnimation = false,
    TransitionType transitionType = TransitionType.defaultTransition,
  }) {
    if (disableAnimation) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionDuration: Duration.zero, // Disable animation
        transitionsBuilder: (_, __, ___, child) => child, // No transition
      );
    }

    // Custom transition for Details Screen (center open animation)
    if (transitionType == TransitionType.detailsScreen) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Center Open Animation
          var curve = Curves.easeOut; // Smooth opening
          var tween = Tween(begin: 0.0, end: 1.0); // Scale transition
          var scaleAnimation =
              animation.drive(tween.chain(CurveTween(curve: curve)));

          return ScaleTransition(
            scale: scaleAnimation,
            child: child,
          );
        },
      );
    }

    // Default Slide Transition (right to left)
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
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
