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
import 'package:barber_time/app/view/screens/owner/owner_home/controller/barber_owner_home_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/inner_widgets/booking_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/inner_widgets/recent_request_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/inner_widgets/total_customer_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/owner_home_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_message/chart_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_message/inbox_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/barber/barber.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/business_profile/business_profile.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/business_profile/business_profile_edit/business_profile_edit.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/business_profile/show_all_barber/show_all_barber.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/following/following_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/job_post/create_job_post.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/job_post/job_post.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/barber_professional_profile.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_favorite/my_favorite_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_feed/my_feed.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/owner_profile_screen.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/edit_owner_profile.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/profile_response_model.dart';
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
import 'package:barber_time/app/view/screens/owner/owner_que/controller/que_controller.dart';
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
import '../view/screens/authentication/sign_up/owner_qr_code.dart';
import '../view/screens/owner/owner_home/inner_widgets/barber_request.dart';
import '../view/screens/owner/owner_home/inner_widgets/hiring_post.dart'
    show HiringPost;
import '../view/screens/owner/owner_home/inner_widgets/total_barber.dart'
    show TotalBarber;
import '../view/screens/owner/owner_profile/business_profile/barber_added/barber_added_screen.dart';
import '../view/screens/owner/owner_profile/flowers/follower_screen.dart';
import '../view/screens/owner/owner_profile/owner_payment/hiring_barber/hiring_barber.dart';
import '../view/screens/owner/owner_profile/owner_payment/invoice_payment/invoice_payment_screen.dart';
import '../view/screens/owner/owner_profile/owner_payment/owner_payment.dart';
import '../view/screens/owner/owner_profile/owner_payment/owner_payment_option/owner_payment_option.dart';
import '../view/screens/owner/owner_profile/personal_info/barber_profile/barber_edit_profile.dart';
import '../view/screens/owner/owner_profile/personal_info/barber_profile/barber_personal_profile.dart';
import '../view/screens/owner/owner_profile/pixmatch/pix_match.dart';
import '../view/screens/owner/owner_profile/settings/blocking/blocking_screen.dart';
import '../view/screens/user/user_profile/user_profile_screen.dart';
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
            child: MyFeed(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.professionalProfile,
          path: RoutePath.professionalProfile.addBasePath,
          pageBuilder: (context, state) {
            final extra = state.extra as Map <String, dynamic>? ?? {};
            final userRole = extra['userRole'] as UserRole?;
            final profileData = extra['profileData'] as ProfileData?;
            final controller = extra['controller'] as OwnerProfileController?;
            final barberId = extra['barberId'] as String?;
            final isForActionButton = extra['isForActionButton'] as bool?;
            final onActionApprove = extra['onActionApprove'] as VoidCallback?;
            final onActionReject = extra['onActionReject'] as VoidCallback?;

            return _buildPageWithAnimation(
              child: ProfessionalProfile(
                userRole: userRole,
                data: profileData,
                controller: controller,
                barberId: barberId,
                isForActionButton: isForActionButton ?? false,
                onActionApprove: onActionApprove,
                onActionReject: onActionReject,
              ),
              state: state,
              transitionType: TransitionType.detailsScreen
            );
          }
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.myFavoriteScreen,
          path: RoutePath.myFavoriteScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: MyFavoriteScreen(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.followingScreen,
          path: RoutePath.followingScreen.addBasePath,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userRole = extra['userRole'] as UserRole;
            final controller = extra['controller'] as OwnerProfileController?;

            return _buildPageWithAnimation(
              child: FollowingScreen(
                userRole: userRole,
                controller: controller!,
              ),
              state: state,
            );
          }
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
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              final isOwner = extra['isOwner'] as bool?;
              final email = extra['email'] as String?;
              final isForgotPassword = extra['isForgotPassword'] as bool?;

              return _buildPageWithAnimation(
                child: OtpScreen(
                  isOwner: isOwner != null && isOwner ? 'true' : 'false',
                  email: email ?? '',
                  isForgotPassword: isForgotPassword != null && isForgotPassword
                      ? true
                      : false,
                ),
                state: state,
              );
            }),

        ///======================= OtpScreen Route =======================
        GoRoute(
          name: RoutePath.resetPasswordScreen,
          path: RoutePath.resetPasswordScreen.addBasePath,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final email = extra['email'] as String?;
            final userRole = extra['userRole'] as UserRole?;
            return _buildPageWithAnimation(
              child: ResetPasswordScreen(email: email ?? '', userRole: userRole!),
              state: state,
            );
          }
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
            disableAnimation: true,
          ),
        ),
    ///=======================barberPersonalProfile =======================
        GoRoute(
          name: RoutePath.barberPersonalProfile,
          path: RoutePath.barberPersonalProfile.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const BarberPersonalProfile(),
            state: state,
          ),
        ),


        ///=======================PixMatch =======================
        GoRoute(
          name: RoutePath.pixMatch,
          path: RoutePath.pixMatch.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const PixMatch(),
            state: state,
          ),
        ),

        ///=======================Blocking =======================
        GoRoute(
          name: RoutePath.blockingScreen,
          path: RoutePath.blockingScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const BlockingScreen(),
            state: state,
          ),
        ),

        ///=======================barberPersonalProfile =======================
        GoRoute(
          name: RoutePath.barberEditProfile,
          path: RoutePath.barberEditProfile.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const BarberEditProfile(),
            state: state,
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
            child:  ProfileScreen(),
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
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userRole = extra['userRole'] as UserRole?;
            final isBarber = extra['isBarber'] as bool? ?? false;

            return _buildPageWithAnimation(
              child: BookingScreen(
                userRole: userRole!,
                isBarber: isBarber,
              ),
              state: state,
            );
          }
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.barberQueScreen,
          path: RoutePath.barberQueScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: BarberQueScreen(),
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
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userRole = extra['userRole'] as UserRole?;
            final isOwner = extra['isOwner'] as bool?;
            final controller = extra['controller'] as OwnerProfileController?;

            
            return _buildPageWithAnimation(
              child:  HiringBarber(
                userRole: userRole!,
                isOwner: isOwner?? false,
                controller: controller !,
              ),
              state: state,
            );
          }
        ),

        ///=======================FollowerScreen  =======================
        GoRoute(
          name: RoutePath.followerScreen,
          path: RoutePath.followerScreen.addBasePath,
          pageBuilder: (context, state){
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userRole = extra['userRole'] as UserRole?;
            final controller = extra['controller'] as OwnerProfileController?;

            return _buildPageWithAnimation(
              child: FollowerScreen(
                userRole: userRole!,
                controller: controller!,
              ),
              state: state,
            );
          }
        ),

        ///=======================OwnerPayment  =======================
        GoRoute(
          name: RoutePath.ownerPayment,
          path: RoutePath.ownerPayment.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const OwnerPayment(),
            state: state,
          ),
        ),

        ///=======================HiringBarberPayment  =======================
        GoRoute(
          name: RoutePath.hiringBarberPayment,
          path: RoutePath.hiringBarberPayment.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const HiringBarberPayment(),
            state: state,
          ),
        ),

        ///=======================InvoicePaymentScreen  =======================
        GoRoute(
          name: RoutePath.invoicePaymentScreen,
          path: RoutePath.invoicePaymentScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const InvoicePaymentScreen(),
            state: state,
          ),
        ),

        ///=======================BarberAddedScreen  =======================
        GoRoute(
          name: RoutePath.barberAddedScreen,
          path: RoutePath.barberAddedScreen.addBasePath,
          pageBuilder: (context, state){
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userRole = extra['userRole'] as UserRole?;
            final controller = extra['controller'] as OwnerProfileController?;

            return _buildPageWithAnimation(
              child: BarberAddedScreen(
                userRole: userRole!,
                controller: controller!,
              ),
              state: state,
            );
          }
        ),
        // show all barber
          GoRoute(
          name: RoutePath.showAllBarber,
          path: RoutePath.showAllBarber.addBasePath,
          pageBuilder: (context, state){
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userRole = extra['userRole'] as UserRole?;
            final controller = extra['controller'] as OwnerProfileController?;

            return _buildPageWithAnimation(
              child: ShowAllBarber(
                userRole: userRole!,
                controller: controller!,
              ),
              state: state,
            );
          }
        ),

     ///=======================OwnerPaymentOption  =======================
        GoRoute(
          name: RoutePath.ownerPaymentOption,
          path: RoutePath.ownerPaymentOption.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  OwnerPaymentOption(),
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
            transitionType: TransitionType.detailsScreen,
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
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userRole = extra['userRole'] as UserRole?;
            final controller = extra['controller'] as OwnerProfileController?;

            return _buildPageWithAnimation(
              child: BusinessProfile(
                userRole: userRole!,
                controller: controller!,
              ),
              state: state,
            );
          }
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
            transitionType: TransitionType.detailsScreen,
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
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userRole = extra['userRole'] as UserRole?;

            // Try to resolve professional data from several possible shapes:
            // - a BarberProfile under 'professionalData'
            // - a List<BarberProfile> under 'professionalData' (take first)
            // - legacy 'data' which is a ProfileData (create a minimal BarberProfile)
            dynamic profExtra = extra['professionalData'] ?? extra['data'];
            BarberProfile? professionalData;

            if (profExtra is BarberProfile) {
              professionalData = profExtra;
            } else if (profExtra is List && profExtra.isNotEmpty && profExtra.first is BarberProfile) {
              professionalData = profExtra.first as BarberProfile;
            } else if (profExtra is ProfileData) {
              // Create a minimal BarberProfile from ProfileData so the edit screen can still open.
              professionalData = BarberProfile(
                id: profExtra.id,
                userId: profExtra.id,
                saloonOwnerId: profExtra.id,
                currentWorkDes: null,
                bio: null,
                portfolio: <String>[],
                isAvailable: false,
                experienceYears: null,
                skills: <String>[],
                followerCount: profExtra.followerCount,
                followingCount: profExtra.followingCount,
                ratingCount: 0,
                avgRating: 0.0,
                createdAt: null,
                updatedAt: null,
              );
            }

            final controller = extra['controller'] as OwnerProfileController?;

            return _buildPageWithAnimation(
              child: EditProfessionalProfile(
                userRole: userRole!,
                professionalData: professionalData ?? BarberProfile(
                  id: '',
                  userId: '',
                  saloonOwnerId: '',
                  currentWorkDes: '',
                  bio: null,
                  portfolio: <String>[],
                  isAvailable: false,
                  experienceYears: '',
                  skills: <String>[],
                  followerCount: 0,
                  followingCount: 0,
                  ratingCount: 0,
                  avgRating: 0.0,
                  createdAt: null,
                  updatedAt: null,
                ),
                controller: controller!,
              ),
              state: state,
             
            );
          }
        ),

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
            transitionType: TransitionType.detailsScreen,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.barberHistoryScreen,
          path: RoutePath.barberHistoryScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: BarberHistoryScreen(),
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
            pageBuilder: (context, state) {
              final extra = state.extra;
              bool isEdit = false;
              dynamic item;
              String? image;

              if (extra is Map<String, dynamic>) {
                isEdit = extra['isEdit'] as bool? ?? false;
                // accept either 'feedItem' or legacy 'item' key
                item = extra['feedItem'] ?? extra['item'];
                image = extra['image'] as String?;
              } else if (extra is UserRole) {
                isEdit = false;
              }

              return _buildPageWithAnimation(
                child: BarberFeed(
                  isEdit: isEdit,
                  item: item,
                  image: image,
                ),
                state: state,
                disableAnimation: true,
              );
            }),

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
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userRole = extra['userRole'] as UserRole?;
            final profileData = extra['profileData'] as ProfileData;
            final controller = extra['controller'] as OwnerProfileController?;

            return _buildPageWithAnimation(
              child: PersonalInfo(
                userRole: userRole,
                data: profileData,
                controller: controller!,
              ),
              state: state,
            );
          }
        ),

        ///=======================PersonalInfo  =======================
        GoRoute(
          name: RoutePath.feedAll,
          path: RoutePath.feedAll.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  FeedAll(),
            state: state,
          ),
        ),

        ///=======================EditOwnerProfile  =======================
        GoRoute(
          name: RoutePath.editOwnerProfile,
          path: RoutePath.editOwnerProfile.addBasePath,
          pageBuilder: (context, state){
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userRole = extra['userRole'] as UserRole?;
            final profileData = extra['profileData'] as ProfileData;
            final controller = extra['controller'] as OwnerProfileController?;

            return _buildPageWithAnimation(
              child: EditOwnerProfile(
                userRole: userRole!,
                data: profileData,
                controller: controller!,
              ),
              state: state,
            );
          }
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
            child: ChangePasswordScreen(),
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
            child: PrivacyPolicyScreen(),
            state: state,
          ),
        ),

        ///=======================TermsScreen  =======================
        GoRoute(
          name: RoutePath.termsScreen,
          path: RoutePath.termsScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: TermsScreen(),
            state: state,
          ),
        ),

        ///=======================Job Post  =======================
        GoRoute(
          name: RoutePath.jobPost,
          path: RoutePath.jobPost.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  JobPost(),
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
            transitionType: TransitionType.detailsScreen,
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

        ///=======================OwnerQrCode =======================
        GoRoute(
          name: RoutePath.ownerQrCode,
          path: RoutePath.ownerQrCode.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const OwnerQrCode(),
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
            transitionType: TransitionType.detailsScreen,
          ),
        ),

        ///=======================totalScreen =======================
        GoRoute(
          name: RoutePath.totalCustomerScreen,
          path: RoutePath.totalCustomerScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const TotalCustomerScreen(),
            state: state,
            transitionType: TransitionType.detailsScreen,
          ),
        ),

        ///=======================TotalBarber =======================
        GoRoute(
          name: RoutePath.totalBarber,
          path: RoutePath.totalBarber.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const TotalBarber(),
            state: state,
            transitionType: TransitionType.detailsScreen,
          ),
        ),

        ///=======================hiringPost =======================
        GoRoute(
          name: RoutePath.hiringPost,
          path: RoutePath.hiringPost.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const HiringPost(),
            state: state,
            transitionType: TransitionType.detailsScreen,
          ),
        ),

        ///=======================barberRequest =======================
        GoRoute(
          name: RoutePath.barberRequest,
          path: RoutePath.barberRequest.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const BarberRequest(),
            state: state,
            transitionType: TransitionType.detailsScreen,
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.queScreen,
          path: RoutePath.queScreen.addBasePath,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userRole = extra['userRole'] as UserRole?;
            final controller = extra['controller'] as QueController?;
            final barberId = extra['barberId'] as String?;

            return _buildPageWithAnimation(
              child: QueScreen(
                userRole: userRole!,
                controller: controller!,
                barberId: barberId!, 
              ),
              state: state,
            );
          }
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
              child:  OwnerQue(), state: state, disableAnimation: true),
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
            child: RateScreen(),
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
            transitionType: TransitionType.detailsScreen,
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.shopProfileScreen,
          path: RoutePath.shopProfileScreen.addBasePath,
          pageBuilder: (context, state){
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userId = extra['userId'] as String?;
            final userRole = extra['userRole'] as UserRole?;
            final controller = extra['controller'];

            return _buildPageWithAnimation(
              child: ShopProfileScreen(
                userId: userId ?? '',
                userRole: userRole!,
                controller: controller,
              ),
              state: state,
            );
          }
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
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userRole = extra['userRole'] as UserRole?;
            final controller = extra['controller'] as BarberOwnerHomeController?;

            return _buildPageWithAnimation(
              child: OwnerRequestBooking(
                userRole: userRole!,
                controller: controller!,
              ),
              state: state,
            );
          }
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.chooseBarberScreen,
          path: RoutePath.chooseBarberScreen.addBasePath,
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
          path: RoutePath.summeryScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const SummeryScreen(),
            state: state,
            // transitionType: TransitionType
            //     .detailsScreen, // Custom transition type for detail screens
          ),
        ),

        ///======================= =======================
        GoRoute(
          name: RoutePath.userProfileScreen,
          path: RoutePath.userProfileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const UserProfileScreen(),
              state: state,
              disableAnimation: true),
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
