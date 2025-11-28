import 'package:barber_time/app/view/screens/barber/barber_feed/controller/mixin_barber_crud.dart';
import 'package:get/get.dart';

class BarberFeedController extends GetxController with BarberFeedCRUDMixin {
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllFeeds();
  }
}
