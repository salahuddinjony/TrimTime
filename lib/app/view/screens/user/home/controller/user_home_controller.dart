import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:get/get.dart';

class UserHomeController extends GetxController{



  //>>>>>>>>>>>>>>>>>>✅✅ Category List✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


  final List<Map<String, dynamic>>  userHomeList = [
    {
      "icon": Assets.icons.bookings.svg(),
      "title": "Bookings",
    },

    {
      "icon": Assets.icons.loyalitys.svg(),
      "title": "Loyalty",
    },

    {
      "icon": Assets.icons.ques.svg(),
      "title": "Queue",
    },
    {
      "icon": Assets.icons.reviews.svg(),
      "title": "Review",
    },
    {
      "icon": Assets.icons.tips.svg(),
      "title": "Tips",
    },   {
      "icon": Assets.icons.mapview.svg(),
      "title": "MapView",
    },

  ];
}