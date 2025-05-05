import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewScreen extends StatelessWidget {
  MapViewScreen({super.key});

  // Controller for managing the current location and map state
  final Rx<LatLng> currentPosition =
      LatLng(0.0, 0.0).obs; // Observable for position
  final Rx<Marker?> currentMarkerLocation =
      Rx<Marker?>(null); // Observable for marker

  // Function to get the current location using the Google Maps SDK
  Future<void> getCurrentLocation(GoogleMapController controller) async {
    // Request the current position
    final LatLng position =
        await controller.getLatLng(ScreenCoordinate(x: 0, y: 0));

    // Update the current position
    currentPosition.value = position;

    // Create and update the marker
    currentMarkerLocation.value = Marker(
      markerId: MarkerId('current_location'),
      position: position,
      infoWindow: InfoWindow(title: 'Your Location'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarContent: AppStrings.mapView,
        iconData: Icons.arrow_back,
      ),
      body: Obx(() {
        return GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            // Get current location when the map is created
            getCurrentLocation(controller);
          },
          initialCameraPosition: CameraPosition(
            target: currentPosition.value,
            // Set initial position to current position
            zoom: 14.0,
          ),
          myLocationEnabled: true,
          // Show current location on map
          myLocationButtonEnabled: true,
          // Enable location button
          cameraTargetBounds: CameraTargetBounds.unbounded,
          markers: currentMarkerLocation.value != null
              ? {currentMarkerLocation.value!} // Show the marker if available
              : {},
        );
      }),
    );
  }
}
