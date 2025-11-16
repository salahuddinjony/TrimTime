import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/mixin_get_barber_with_date_time/mixin_get_barber_with_date_time.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/mixin_non_registered_bookings/mixin_non_registered_bookings.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/mixin_que_management.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/mixin_services/mixin/mixin_get_services.dart';
import 'package:get/get.dart';

class QueController extends GetxController
    with
        MixinGetServices,
        GetBarberWithDateTimeMixin,
        MixinNonRegisteredBookings,
        QueManagementMixin {
  var selectedValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQueList();
    selectedValue.value = '';
  }
}
