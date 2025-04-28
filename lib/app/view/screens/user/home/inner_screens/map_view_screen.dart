import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';


class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white50,
      appBar: CustomAppBar(
        appBarContent: AppStrings.mapView,
        appBarBgColor: AppColors.linearFirst,
        iconData: Icons.arrow_back,
      ),

    );
  }
}
