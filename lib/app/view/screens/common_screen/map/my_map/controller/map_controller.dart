import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MapController extends GetxController {
  // Observable variables
  var cameraPosition =
      const CameraPosition(target: LatLng(37.7749, -122.4194), zoom: 12).obs;
  var markers = <Marker>{}.obs;
  GoogleMapController? mapController;
  RxBool isClean = false.obs;
  var suggestions = <Map<String, dynamic>>[].obs;
  var selectedLocation = Rxn<Map<String, dynamic>>();
  var status = Rx<RxStatus>(RxStatus.success());
  final String apiKey = dotenv.env['API_KEY']!;

  // for profile screen
  double? longitude;
  double? latitude;

  @override
  void onInit() {
    super.onInit();

    longitude =
        Get.arguments != null && Get.arguments['long'] != null
            ? (Get.arguments['long'] as num).toDouble()
            : null;

    latitude =
        Get.arguments != null && Get.arguments['lat'] != null
            ? (Get.arguments['lat'] as num).toDouble()
            : null;

    // Only get user location if both latitude and longitude are null
    if (latitude == null && longitude == null) {
      _setDefaultLocation();
    } else {
      getUserLocation();
    }

    _addInitialMarker(latitude, longitude);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    update();
  }

  void _addInitialMarker([double? lat, double? long]) {
    markers.add(
      Marker(
        markerId: const MarkerId('initial_marker'),
        position: LatLng(lat ?? 37.7749, long ?? -122.4194),
        infoWindow: const InfoWindow(title: 'San Francisco'),
      ),
    );
  }

  // Set default location to San Francisco
  void _setDefaultLocation() {
    const double defaultLat = 37.7749;
    const double defaultLng = -122.4194;

    cameraPosition.value = const CameraPosition(
      target: LatLng(defaultLat, defaultLng),
      zoom: 12,
    );

    markers.add(
      const Marker(
        markerId: MarkerId('default_location'),
        position: LatLng(defaultLat, defaultLng),
        infoWindow: InfoWindow(title: 'San Francisco'),
      ),
    );

    // Set default location as selected
    selectedLocation.value = {
      'latitude': defaultLat,
      'longitude': defaultLng,
      'address': 'San Francisco, CA, USA',
    };

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition.value),
    );
  }

  Future<void> getUserLocation() async {
    // If both latitude and longitude are provided, use them directly
    if (latitude != null && longitude != null) {
      final double targetLat = latitude!;
      final double targetLng = longitude!;

      cameraPosition.value = CameraPosition(
        target: LatLng(targetLat, targetLng),
        zoom: 15,
      );

      markers.add(
        Marker(
          markerId: const MarkerId('provided_location'),
          position: LatLng(targetLat, targetLng),
          infoWindow: const InfoWindow(title: 'Provided Location'),
        ),
      );

      // Fetch address via reverse geocoding
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$targetLat,$targetLng&key=$apiKey';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      String address = 'Unknown Address';
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        address = data['results'][0]['formatted_address'];
      }

      // Set provided location as selected
      selectedLocation.value = {
        'latitude': targetLat,
        'longitude': targetLng,
        'address': address,
      };

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition.value),
      );
      return;
    }

    // Only get current device location if no coordinates are provided
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      _setDefaultLocation();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permissions denied.');
        _setDefaultLocation();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Location permissions permanently denied.');
      _setDefaultLocation();
      return;
    }

    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    cameraPosition.value = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15,
    );

    markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    );

    // Fetch address via reverse geocoding
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    String address = 'Unknown Address';
    if (data['status'] == 'OK' && data['results'].isNotEmpty) {
      address = data['results'][0]['formatted_address'];
    }

    // Set current location as selected by default
    selectedLocation.value = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address,
    };

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition.value),
    );
  }

  // Handle map tap to mark a location
  Future<void> onMapTap(LatLng position) async {
    try {
      // Fetch address via reverse geocoding
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      String address = 'Unknown Address';
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        address = data['results'][0]['formatted_address'];
      }

      // Update selected location
      selectedLocation.value = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address,
      };

      // Update marker
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
          infoWindow: InfoWindow(title: address),
        ),
      );

      // Move camera to the tapped position
      cameraPosition.value = CameraPosition(target: position, zoom: 15);
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition.value),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to get address: $e');
    }
  }

  // Fetch place autocomplete suggestions
  Future<void> fetchPlaceSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      isClean.value = false;
      return;
    }

    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey&types=(cities)';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        suggestions.value =
            List<Map<String, dynamic>>.from(data['predictions'])
                .map(
                  (prediction) => {
                    'description': prediction['description'],
                    'place_id': prediction['place_id'],
                  },
                )
                .toList();
        isClean.value = true;
      } else {
        suggestions.clear();
        // Get.snackbar('Error', 'No suggestions found for "$query".');
      }
    } catch (e) {
      suggestions.clear();
      Get.snackbar('Error', 'Failed to fetch suggestions: $e');
    }
  }

  // Search for a place using place_id from autocomplete
  Future<void> searchPlaceById(String placeId) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,geometry,formatted_address&key=$apiKey';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final place = data['result'];
        final lat = place['geometry']['location']['lat'];
        final lng = place['geometry']['location']['lng'];
        final name = place['name'];
        final address = place['formatted_address'];

        // Update selected location
        selectedLocation.value = {
          'latitude': lat,
          'longitude': lng,
          'address': address,
        };

        cameraPosition.value = CameraPosition(
          target: LatLng(lat, lng),
          zoom: 15,
        );

        markers.clear();
        markers.add(
          Marker(
            markerId: const MarkerId('searched_place'),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: name),
          ),
        );

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition.value),
        );
        suggestions.clear();
      } else {
        // Get.snackbar('Error', 'No results found for selected place.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to search place: $e');
    }
  }

  // Search for a place using text query
  Future<void> searchPlace(String query) async {
    if (query.isEmpty) {
      isClean.value = false;
      return;
    }

    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final place = data['results'][0];
        final lat = place['geometry']['location']['lat'];
        final lng = place['geometry']['location']['lng'];
        final name = place['name'];
        final address = place['formatted_address'] ?? name;

        // Update selected location
        selectedLocation.value = {
          'latitude': lat,
          'longitude': lng,
          'address': address,
        };

        cameraPosition.value = CameraPosition(
          target: LatLng(lat, lng),
          zoom: 15,
        );

        markers.clear();
        markers.add(
          Marker(
            markerId: const MarkerId('searched_place'),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: name),
          ),
        );

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition.value),
        );
      } else {
        // Get.snackbar('Error', 'No results found for "$query".');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to search place: $e');
    }
  }

  void setIsClean(bool value) => isClean.value = value;

  // Clear selected location
  void clearSelectedLocation() {
    selectedLocation.value = null;
    markers.clear();
    suggestions.clear();
    isClean.value = false;

    // If both latitude and longitude are null, set default location
    if (latitude == null && longitude == null) {
      _setDefaultLocation();
    } else {
      getUserLocation();
    }
  }


}
