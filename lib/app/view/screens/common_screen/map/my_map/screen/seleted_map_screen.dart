import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:barber_time/app/view/screens/common_screen/map/my_map/controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectedMapScreen extends StatefulWidget {
  final UserRole? userRole;
  const SelectedMapScreen({super.key, this.userRole});

  @override
  State<SelectedMapScreen> createState() => _SelectedMapScreenState();
}

class _SelectedMapScreenState extends State<SelectedMapScreen> {
  late MapController mapController;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    mapController = Get.find<MapController>();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFromProfileCompletion =
        Get.arguments?['isFromProfileCompletion'] ?? false;

    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation if coming from profile completion
        return !isFromProfileCompletion;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          appBarContent: 'Select Location'.tr,
          iconData: isFromProfileCompletion ? null : Icons.arrow_back,
        ),
        body: Stack(
          children: [
            Obx(() {
              return GoogleMap(
                initialCameraPosition: mapController.cameraPosition.value,
                onMapCreated: mapController.onMapCreated,
                markers: mapController.markers.toSet(),
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onTap: (LatLng position) {
                  mapController.onMapTap(position);
                  searchController.text =
                      mapController.selectedLocation.value?['address'] ??
                          'San Francisco';
                  mapController.setIsClean(true);
                },
              );
            }),
            Positioned(
              top: 30,
              right: 30,
              left: 30,
              child: Column(
                children: [
                  Obx(() {
                    return CustomTextField(
                      textEditingController: searchController,
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.app,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          mapController.setIsClean(true);
                          mapController.fetchPlaceSuggestions(value);
                        } else {
                          mapController.setIsClean(false);
                          mapController.suggestions.clear();
                        }
                      },
                      suffixIcon: mapController.isClean.value
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: AppColors.app,
                              ),
                              onPressed: () {
                                searchController.clear();
                                mapController.clearSelectedLocation();
                                mapController.suggestions.clear();
                                mapController.setIsClean(false);
                              },
                            )
                          : null,
                      hintText: 'Enter your address'.tr,
                      hintStyle: const TextStyle(color: AppColors.app),
                      fillColor: AppColors.white,
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty) {
                          mapController.searchPlace(value);
                          mapController.suggestions.clear();
                        }
                      },
                    );
                  }),
                  Obx(() {
                    if (mapController.suggestions.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: mapController.suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion =
                              mapController.suggestions[index]['description'];
                          return ListTile(
                            title: Text(
                              suggestion,
                              style: const TextStyle(color: AppColors.app),
                            ),
                            onTap: () {
                              searchController.text = suggestion;
                              mapController.searchPlaceById(
                                mapController.suggestions[index]['place_id'],
                              );
                              mapController.setIsClean(true);
                              mapController.suggestions.clear();
                            },
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            Obx(() {
              return Positioned(
                bottom: 30,
                right: 30,
                left: 30,
                child: mapController.status.value.isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onTap: () {
                          if (mapController.selectedLocation.value != null) {
                            if (Get.arguments != null &&
                                Get.arguments['returnData'] == true) {
                              Get.back(
                                result: mapController.selectedLocation.value,
                              );
                            }
                            // else {
                            //   mapController.updateContractorData();
                            // }
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please select a location first.',
                            );
                          }
                        },
                        title: "Continue".tr,
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
