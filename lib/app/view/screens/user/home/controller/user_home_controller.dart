import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_booking_management.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_feeds_management.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_seloon_mng/mixin_selon_management.dart';
import 'package:barber_time/app/view/screens/common_screen/my_loyality/mixin/mixin_loyality.dart';
import 'package:barber_time/app/view/screens/common_screen/shop_profile/mixin_give_rating_with_images.dart';
import 'package:barber_time/app/view/screens/common_screen/shop_profile/mixin_select_multiple_images.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/controller/mixin/mixin_date_wise_bookings.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/mixin/mixin_get_all_my_fav.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/mixin/mixin_get_revires.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/mixin_get_barber_with_date_time/mixin_get_barber_with_date_time.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/mixin_non_registered_bookings/mixin_non_registered_bookings.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/mixin_services/mixin/mixin_get_services.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/queue_management/mixin_que_management.dart';
import 'package:barber_time/app/view/screens/user/home/controller/mixin/mixin_get_salons.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/mixin/mixin_create_booking_or_gueue.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/mixin/mixin_get_barber_datewise.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/mixin/mixin_selected_barber_free_slot.dart';
import 'package:barber_time/app/view/screens/user/home/customer_review/mixin/mixin_get_customer_review.dart';
import 'package:barber_time/app/view/screens/user/saved/controller/mixin/mixin_favourite_shop.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum tags { nearby, topRated, searches, customerReviews }

class UserHomeController extends GetxController
    with
        MixinGetSalons,
        MixinFeedsManagement,
        MixinSelonManagement,
        DateWiseBookingsMixin,
        MixinGetBarberDatewise,
        MixinSelectedBarberFreeSlot,
        MixinCreateBookingOrQueue,
        MixinGetAllMyFav,
        FavoriteShopMixin,
        BookingManagementMixin,
        SelectMultipleImagesMixin,
        GiveRatingWithImagesMixin,
        MixinGetCustomerReview,
        MixinGetReviews,
        MixinGetServices,
        GetBarberWithDateTimeMixin,
        MixinNonRegisteredBookings,
        QueManagementMixin,
        MixinLoyality {
  // Current location
  Rxn<double> currentLatitude = Rxn<double>();
  Rxn<double> currentLongitude = Rxn<double>();

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocationAndFetchSalons();
    getHomeFeeds();
  }

  Future<void> _getCurrentLocationAndFetchSalons() async {
    double? lat;
    double? lng;
    
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Show dialog to enable location services
        _showLocationDialog(
          title: 'Location Services Disabled',
          message: 'Please enable location services to find nearby salons.',
          onEnable: () async {
            await Geolocator.openLocationSettings();
          },
        );
        // Use default location if service is disabled
        lat = 23.9323;
        lng = 90.4170;
      } else {
        // Check location permission
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            // Show dialog if permission denied
            _showLocationDialog(
              title: 'Location Permission Required',
              message: 'Please allow location access to find nearby salons.',
              onEnable: () async {
                await Geolocator.openAppSettings();
              },
            );
            // Use default location if permission denied
            lat = 23.9323;
            lng = 90.4170;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          // Show dialog if permission permanently denied
          _showLocationDialog(
            title: 'Location Permission Denied',
            message: 'Location permission is permanently denied. Please enable it from app settings.',
            onEnable: () async {
              await Geolocator.openAppSettings();
            },
          );
          // Use default location if permission permanently denied
          lat = 23.9323;
          lng = 90.4170;
        } else if (permission == LocationPermission.whileInUse || 
                   permission == LocationPermission.always) {
          // Get current position
          Position position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
          );

          // Store current location
          currentLatitude.value = position.latitude;
          currentLongitude.value = position.longitude;
          lat = position.latitude;
          lng = position.longitude;
        }
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      // Fallback to default location
      lat = 23.9323;
      lng = 90.4170;
    }

    // Fetch nearby salons and top rated salons in parallel using the same lat/lng
    await Future.wait([
      fetchSelons(
        tag: tags.nearby,
        lat: lat,
        lng: lng,
      ),
      fetchSelons(
        tag: tags.topRated,
        lat: lat,
        lng: lng,
      ),
    ]);
  }

  void _showLocationDialog({
    required String title,
    required String message,
    required VoidCallback onEnable,
  }) {
    final context = Get.context;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          backgroundColor: AppColors.white,
          title: Row(
            children: [
              Icon(
                Icons.location_off,
                color: AppColors.red,
                size: 28.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomText(
                  text: title,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          content: CustomText(
            text: message,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: CustomText(
                text: 'Cancel',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.gray300,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onEnable();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.app,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: CustomText(
                text: 'Enable',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getbarberWithDate(
      {required String barberId, required String date}) async {
    await getBarberDatewiseBookings(barberId: barberId, date: date);
  }

  Future<void> getFreeSlots(
      {required String barberId,
      required String saloonId,
      required String date}) async {
    await getSelectedBarberFreeSlots(
        barberId: barberId, saloonId: saloonId, date: date);
  }

// Clear booking-related fields
  void clearSeloonBookingFields() {
    selectedServicesIds.clear();
    selectedServices.clear();
    seletedBarberFreeSlots.clear();
    selectedBarberId.value = '';
  }
}
