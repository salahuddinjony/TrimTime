import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_feeds_management.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_selon_management.dart';
import 'package:barber_time/app/view/screens/user/home/controller/mixin/mixin_get_salons.dart';
import 'package:get/get.dart';

enum tags { nearby, topRated, searches }

class UserHomeController extends GetxController
    with MixinGetSalons, MixinFeedsManagement, MixinSelonManagement {
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
}
