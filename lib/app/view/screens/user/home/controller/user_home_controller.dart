import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_booking_management.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_feeds_management.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_seloon_mng/mixin_selon_management.dart';
import 'package:barber_time/app/view/screens/common_screen/shop_profile/mixin_give_rating_with_images.dart';
import 'package:barber_time/app/view/screens/common_screen/shop_profile/mixin_select_multiple_images.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/controller/mixin/mixin_date_wise_bookings.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/mixin/mixin_get_all_my_fav.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/mixin/mixin_get_revires.dart';
import 'package:barber_time/app/view/screens/user/home/controller/mixin/mixin_get_salons.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/mixin/mixin_create_booking_or_gueue.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/mixin/mixin_get_barber_datewise.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/mixin/mixin_selected_barber_free_slot.dart';
import 'package:barber_time/app/view/screens/user/home/customer_review/mixin/mixin_get_customer_review.dart';
import 'package:barber_time/app/view/screens/user/saved/controller/mixin/mixin_favourite_shop.dart';
import 'package:get/get.dart';

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
        MixinGetReviews {
  @override
  void onInit() {
    super.onInit();
    fetchSelons(tag: tags.nearby);
    fetchSelons(tag: tags.topRated);
    getHomeFeeds();
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
