import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_feeds_management.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_seloon_mng/mixin_selon_management.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/controller/mixin/mixin_date_wise_bookings.dart';
import 'package:barber_time/app/view/screens/user/home/controller/mixin/mixin_get_salons.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/mixin/mixin_get_barber_datewise.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/mixin/mixin_selected_barber_free_slot.dart';
import 'package:get/get.dart';

enum tags { nearby, topRated, searches }

class UserHomeController extends GetxController
    with
        MixinGetSalons,
        MixinFeedsManagement,
        MixinSelonManagement,
        DateWiseBookingsMixin,
        MixinGetBarberDatewise,
        MixinSelectedBarberFreeSlot
         {
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

  Future<void> getbarberWithDate({required String barberId, required String date}) async{
   await getBarberDatewiseBookings(barberId: barberId, date: date);
  }
}
