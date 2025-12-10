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

    // Try to get location from Get.arguments first (for backward compatibility)
    longitude =
        Get.arguments != null && Get.arguments['long'] != null
            ? (Get.arguments['long'] as num).toDouble()
            : null;

    latitude =
        Get.arguments != null && Get.arguments['lat'] != null
            ? (Get.arguments['lat'] as num).toDouble()
            : null;

    // If not found in Get.arguments, try GoRouter (if available)
    // Note: GoRouter state needs to be accessed from the widget context
    // So we'll handle it in the screen widget instead

    // Only get user location if both latitude and longitude are null
    if (latitude == null && longitude == null) {
      _setDefaultLocation();
    } else if (latitude != null && longitude != null) {
      // Set camera position for provided location
      cameraPosition.value = CameraPosition(
        target: LatLng(latitude!, longitude!),
        zoom: 15,
      );
      // Don't call getUserLocation() here - let the screen widget handle marker creation
      // This prevents clearing markers that will be set by the screen
    } else {
      getUserLocation();
    }

    // Only add initial marker if we don't have specific coordinates
    if (latitude == null && longitude == null) {
      _addInitialMarker(latitude, longitude);
    }
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

    // Clear existing markers before adding new one
    markers.clear();
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

      // Clear existing markers before adding new one
      markers.clear();
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

    // Clear existing markers before adding new one
    markers.clear();
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

  // Add nearby salon markers
  void addNearbySalonMarkers(List<dynamic> salons, {String? selectedSalonId}) {
    // Clear existing salon markers (but keep user location marker)
    Marker? userLocationMarker;
    for (var marker in markers) {
      final markerId = marker.markerId.value;
      if (markerId == 'user_location' || 
          markerId == 'current_location' ||
          markerId == 'provided_location' ||
          markerId == 'initial_marker' ||
          markerId == 'default_location') {
        userLocationMarker = marker;
        break;
      }
    }
    
    markers.clear();
    
    // Re-add user location marker if it exists
    if (userLocationMarker != null) {
      markers.add(userLocationMarker);
    }

    // Add salon markers
    for (var salon in salons) {
      double salonLat = 0.0;
      double salonLng = 0.0;
      
      // Handle both Map and object types
      if (salon is Map) {
        salonLat = (salon['latitude'] ?? 0.0) as double;
        salonLng = (salon['longitude'] ?? 0.0) as double;
      } else {
        salonLat = (salon.latitude ?? 0.0) as double;
        salonLng = (salon.longitude ?? 0.0) as double;
      }
      
      if (salonLat != 0.0 && salonLng != 0.0) {
        String salonId = '';
        String shopName = 'Salon';
        String shopAddress = '';
        int queueCount = 0;
        
        if (salon is Map) {
          salonId = salon['userId'] ?? salon['id'] ?? '';
          shopName = salon['shopName'] ?? 'Salon';
          shopAddress = salon['shopAddress'] ?? '';
          queueCount = (salon['queue'] ?? 0) as int;
        } else {
          salonId = salon.userId ?? salon.id ?? '';
          shopName = salon.shopName ?? 'Salon';
          shopAddress = salon.shopAddress ?? '';
          queueCount = salon.queue ?? 0;
        }
        
        final isSelected = selectedSalonId != null && salonId == selectedSalonId;
        
        // Build info window snippet with queue count (always show)
        String infoSnippet = '$shopAddress\nQueue: $queueCount';
        
        markers.add(
          Marker(
            markerId: MarkerId('salon_$salonId'),
            position: LatLng(salonLat, salonLng),
            icon: isSelected 
                ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
                : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(
              title: shopName,
              snippet: infoSnippet,
            ),
            onTap: () {
              // Handle marker tap if needed
            },
          ),
        );
      }
    }
  }

  // Set camera to show all markers
  void fitBoundsToMarkers() {
    if (markers.isEmpty) return;

    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (var marker in markers) {
      final lat = marker.position.latitude;
      final lng = marker.position.longitude;
      
      minLat = lat < minLat ? lat : minLat;
      maxLat = lat > maxLat ? lat : maxLat;
      minLng = lng < minLng ? lng : minLng;
      maxLng = lng > maxLng ? lng : maxLng;
    }

    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;
    
    // Calculate zoom level based on bounds
    double latDiff = maxLat - minLat;
    double lngDiff = maxLng - minLng;
    double maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
    
    double zoom = 12.0;
    if (maxDiff > 0) {
      if (maxDiff < 0.01) {
        zoom = 15.0;
      } else if (maxDiff < 0.05) {
        zoom = 13.0;
      } else if (maxDiff < 0.1) {
        zoom = 12.0;
      } else {
        zoom = 11.0;
      }
    }

    final newCameraPosition = CameraPosition(
      target: LatLng(centerLat, centerLng),
      zoom: zoom,
    );
    
    cameraPosition.value = newCameraPosition;

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  // Reset map controller state
  void resetState() {
    markers.clear();
    selectedLocation.value = null;
    suggestions.clear();
    isClean.value = false;
    latitude = null;
    longitude = null;
    status.value = RxStatus.success();
  }


}
