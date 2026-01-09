import 'package:barber_time/app/view/screens/owner/owner_profile/pixmatch/mixin/mixin_analyze_salon.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PixMatchController extends GetxController with MixinAnalyzeSalon {
  // Current location
  Rxn<double> currentLatitude = Rxn<double>();
  Rxn<double> currentLongitude = Rxn<double>();

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Use default location if service is disabled
        currentLatitude.value = 23.8156;
        currentLongitude.value = 90.48;
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Use default location if permission denied
          currentLatitude.value = 23.8156;
          currentLongitude.value = 90.48;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Use default location if permission permanently denied
        currentLatitude.value = 23.8156;
        currentLongitude.value = 90.48;
        return;
      }

      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        // Get current position
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );

        // Store current location
        currentLatitude.value = position.latitude;
        currentLongitude.value = position.longitude;
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      // Fallback to default location
      currentLatitude.value = 23.8156;
      currentLongitude.value = 90.48;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

