
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_border_card/custom_border_card.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/info_controller.dart';
import 'package:barber_time/app/view/screens/barber/barber_que_screen/model/barber_queue_capacity_model.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class BarberQueScreen extends StatelessWidget {
   BarberQueScreen({
    super.key,
  });

    final InfoController infoController = Get.find<InfoController>();


  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.linearFirst,
        title: const Text(AppStrings.que),
      ),
      body: ClipPath(
        clipper: CurvedBannerClipper(),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCEDC4AC), // First color (with opacity)
                Color(0xCCEDC4AC),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child:
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Obx(() {
              if (infoController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final items = infoController.barberQueueCapacity;
              final display = items.isEmpty ? _demoItems : items;

              return RefreshIndicator(
                onRefresh: () async => await infoController.fetchBarberQueueCapacity(),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final BarberQueueCapacityData item = display[index];
                    return CustomBorderCard(
                      title: item.barberName,
                      time: '',
                      price: 'Max capacity: ${item.maxCapacity}',
                      date: '',
                      buttonText: 'Details',
                      isButton: false,
                      onButtonTap: () {},
                      logoImage: CustomNetworkImage(
                        boxShape: BoxShape.circle,
                        imageUrl: item.image ?? AppConstants.demoImage,
                        height: 50,
                        width: 50,
                      ),
                      seeDescriptionTap: () {},
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 5),
                  itemCount: display.length,
                ),
              );
            }),
          )
        ),
      ),
    );
  }

  // Demo items when API returns empty
  List<BarberQueueCapacityData> get _demoItems => [
        BarberQueueCapacityData(
          id: '689dcf8644fa9892246e106e',
          barberId: '68933b39ce32c00fa2c7d90b',
          maxCapacity: 10,
          barberName: 'Goni vai',
          image: 'https://lerirides.nyc3.digitaloceanspaces.com/user-profile-images/1754479578172_man-9377284_1280.jpg',
        ),
         BarberQueueCapacityData(
          id: '689dcf8644fa9892246e1asa06e',
          barberId: '68933b39ce32c00fa2casdsb',
          maxCapacity: 08,
          barberName: 'Salah vai',
          image: 'https://lerirides.nyc3.digitaloceanspaces.com/user-profile-images/1754479578172_man-9377284_1280.jpg',
        ),
      ];
}
