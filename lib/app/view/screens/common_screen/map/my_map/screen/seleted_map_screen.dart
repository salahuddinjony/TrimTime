import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:barber_time/app/view/screens/common_screen/map/my_map/controller/map_controller.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart'
    show UserHomeController;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SelectedMapScreen extends StatefulWidget {
  final UserRole? userRole;
  const SelectedMapScreen({super.key, this.userRole});

  @override
  State<SelectedMapScreen> createState() => _SelectedMapScreenState();
}

class _SelectedMapScreenState extends State<SelectedMapScreen> {
  late MapController mapController;
  final TextEditingController searchController = TextEditingController();
  List<dynamic>? nearbySalons;
  bool showNearbySalons = false;
  String? selectedSalonId;
  Map<String, dynamic>? selectedSalonData;
  GoogleMapController? googleMapController;
  String? currentSelectedMarkerId;
  bool _markersInitialized = false; // Track if markers have been initialized

  @override
  void initState() {
    super.initState();
    mapController = Get.find<MapController>();

    // Get nearby salons from route extra (GoRouter)
    final extra = GoRouter.of(context).state.extra;
    if (extra is Map) {
      nearbySalons = extra['nearbySalons'] as List<dynamic>?;
      showNearbySalons = extra['showNearbySalons'] ?? false;
      selectedSalonId = extra['selectedSalonId'] as String?;

      // Update MapController with lat/lng if provided
      if (extra['lat'] != null && extra['lng'] != null) {
        final lat = (extra['lat'] as num).toDouble();
        final lng = (extra['lng'] as num).toDouble();
        mapController.latitude = lat;
        mapController.longitude = lng;

        // Set camera position after build phase to avoid setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            mapController.cameraPosition.value = CameraPosition(
              target: LatLng(lat, lng),
              zoom: 15,
            );
          }
        });
      }

      // If no salons passed but showNearbySalons is true, get from controller
      if (showNearbySalons && (nearbySalons == null || nearbySalons!.isEmpty)) {
        try {
          final homeController = Get.find<UserHomeController>();
          nearbySalons = homeController.nearbySaloons.toList();
        } catch (e) {
          debugPrint('UserHomeController not found: $e');
        }
      }
    }

    // If showing nearby salons, get current location first
    if (showNearbySalons &&
        mapController.latitude == null &&
        mapController.longitude == null) {
      _getCurrentLocationForMap();
    }

    // Reset map controller state after build phase completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetMapController();
    });
  }

  void _resetMapController() {
    // Clear all markers
    mapController.markers.clear();
    // Clear selected location
    mapController.selectedLocation.value = null;
    // Clear suggestions
    mapController.suggestions.clear();
    // Reset clean state
    mapController.setIsClean(false);
    // Reset status
    mapController.status.value = RxStatus.success();
  }

  /// Create custom marker icon from shop logo
  Future<BitmapDescriptor> _createMarkerFromLogo({
    required String imageUrl,
    required int size,
  }) async {
    try {
      // Fetch image from network
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final Uint8List imageBytes = response.bodyBytes;

        // Decode image
        final ui.Codec codec = await ui.instantiateImageCodec(
          imageBytes,
          targetWidth: size,
          targetHeight: size,
        );
        final ui.FrameInfo frameInfo = await codec.getNextFrame();
        final ui.Image image = frameInfo.image;

        // Create a picture recorder
        final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(pictureRecorder);

        // Draw white circle background
        final Paint backgroundPaint = Paint()..color = Colors.white;
        canvas.drawCircle(
          Offset(size / 2, size / 2),
          size / 2,
          backgroundPaint,
        );

        // Draw border
        final Paint borderPaint = Paint()
          ..color = AppColors.secondary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;
        canvas.drawCircle(
          Offset(size / 2, size / 2),
          size / 2 - 1.5,
          borderPaint,
        );

        // Draw the image in a circle
        final Path clipPath = Path()
          ..addOval(Rect.fromCircle(
            center: Offset(size / 2, size / 2),
            radius: size / 2 - 3,
          ));
        canvas.clipPath(clipPath);

        // Draw image
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromLTWH(3, 3, (size - 6).toDouble(), (size - 6).toDouble()),
          Paint(),
        );

        // Convert to image
        final ui.Picture picture = pictureRecorder.endRecording();
        final ui.Image markerImage = await picture.toImage(size, size);
        final ByteData? byteData = await markerImage.toByteData(
          format: ui.ImageByteFormat.png,
        );
        final Uint8List uint8List = byteData!.buffer.asUint8List();

        return BitmapDescriptor.fromBytes(uint8List);
      }
    } catch (e) {
      debugPrint('Error creating marker from logo: $e');
    }

    // Return default marker if image loading fails
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  }

  Future<void> _getCurrentLocationForMap() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );

      mapController.latitude = position.latitude;
      mapController.longitude = position.longitude;
      await mapController.getUserLocation();
    } catch (e) {
      debugPrint('Error getting location for map: $e');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    // Don't clear markers when navigating away - they should persist
    // Only clear suggestions and selected location
    mapController.selectedLocation.value = null;
    mapController.suggestions.clear();
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
          appBarContent: 'Map View'.tr,
          iconData: isFromProfileCompletion ? null : Icons.arrow_back,
        ),
        body: Stack(
          children: [
            Obx(() {
              // Determine initial camera position - use a stable position to avoid flickering
              CameraPosition initialPosition =
                  mapController.cameraPosition.value;

              // If we have a specific salon location, use it for initial position
              // This prevents the map from starting at default location and then jumping
              if (mapController.latitude != null &&
                  mapController.longitude != null) {
                initialPosition = CameraPosition(
                  target:
                      LatLng(mapController.latitude!, mapController.longitude!),
                  zoom: 15,
                );
              } else if (showNearbySalons &&
                  nearbySalons != null &&
                  nearbySalons!.isNotEmpty) {
                // If we have nearby salons, center on the first one
                final firstSalon = nearbySalons!.first;
                double salonLat = 0.0;
                double salonLng = 0.0;

                if (firstSalon is Map) {
                  salonLat = (firstSalon['latitude'] ?? 0.0) as double;
                  salonLng = (firstSalon['longitude'] ?? 0.0) as double;
                } else {
                  salonLat = firstSalon.latitude ?? 0.0;
                  salonLng = firstSalon.longitude ?? 0.0;
                }

                if (salonLat != 0.0 && salonLng != 0.0) {
                  initialPosition = CameraPosition(
                    target: LatLng(salonLat, salonLng),
                    zoom: 13,
                  );
                }
              }

              return GoogleMap(
                initialCameraPosition: initialPosition,
                onMapCreated: (GoogleMapController controller) async {
                  mapController.onMapCreated(controller);
                  googleMapController = controller;

                  // Wait for map to be fully ready before making any changes
                  await Future.delayed(const Duration(milliseconds: 500));

                  // Only add markers if they haven't been initialized yet
                  // This prevents clearing markers when navigating back
                  if (!_markersInitialized &&
                      showNearbySalons &&
                      nearbySalons != null &&
                      nearbySalons!.isNotEmpty) {
                    // If we have a specific salon (from shop profile), add it as a marker
                    if (selectedSalonId != null && nearbySalons!.length == 1) {
                      final salon = nearbySalons![0];
                      double salonLat = 0.0;
                      double salonLng = 0.0;
                      String shopName = 'Salon';
                      String shopAddress = '';
                      String shopLogo = '';

                      if (salon is Map) {
                        salonLat = (salon['latitude'] ?? 0.0) as double;
                        salonLng = (salon['longitude'] ?? 0.0) as double;
                        shopName = salon['shopName'] ?? 'Salon';
                        shopAddress = salon['shopAddress'] ?? '';
                        shopLogo = salon['shopLogo'] ?? '';
                      } else {
                        salonLat = salon.latitude ?? 0.0;
                        salonLng = salon.longitude ?? 0.0;
                        shopName = salon.shopName ?? 'Salon';
                        shopAddress = salon.shopAddress ?? '';
                        shopLogo = salon.shopLogo ?? '';
                      }

                      if (salonLat != 0.0 && salonLng != 0.0) {
                        // Create custom marker with shop logo
                        final customIcon = shopLogo.isNotEmpty
                            ? await _createMarkerFromLogo(
                                imageUrl: shopLogo, size: 100)
                            : BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRed);

                        // Clear and add marker first (before camera animation to avoid flickering)
                        final markerId = MarkerId('salon_$selectedSalonId');
                        if (!_markersInitialized) {
                          mapController.markers.clear();
                        }
                        mapController.markers.add(
                          Marker(
                            markerId: markerId,
                            position: LatLng(salonLat, salonLng),
                            icon: customIcon,
                            infoWindow: InfoWindow(
                              title: shopName,
                              snippet: shopAddress,
                            ),
                            // When coming from shop profile, don't show bottom sheet on tap
                            // Just show the info window (which is already displayed)
                            onTap: null,
                          ),
                        );
                        _markersInitialized = true; // Mark as initialized

                        // Only animate camera if it's not already at the correct position
                        final currentTarget =
                            mapController.cameraPosition.value.target;
                        final distance =
                            (currentTarget.latitude - salonLat).abs() +
                                (currentTarget.longitude - salonLng).abs();

                        if (distance > 0.01) {
                          // Only animate if position is significantly different
                          final cameraPosition = CameraPosition(
                            target: LatLng(salonLat, salonLng),
                            zoom: 15,
                          );

                          mapController.cameraPosition.value = cameraPosition;
                          await controller.animateCamera(
                            CameraUpdate.newCameraPosition(cameraPosition),
                          );
                        }

                        // Show info window after a short delay
                        await Future.delayed(const Duration(milliseconds: 400));
                        try {
                          controller.showMarkerInfoWindow(markerId);
                        } catch (e) {
                          debugPrint('Error showing info window: $e');
                        }
                      }
                    } else {
                      // Multiple salons - add all markers with click handlers
                      // Check if coming from shop profile (has selectedSalonId) or from MapView
                      final isFromShopProfile = selectedSalonId != null;

                      // Prepare all markers first
                      final Set<Marker> newMarkers = {};

                      // Add markers for all nearby salons
                      for (var salon in nearbySalons!) {
                        double salonLat = 0.0;
                        double salonLng = 0.0;
                        String shopName = 'Salon';
                        String shopAddress = '';
                        String salonUserId = '';
                        String shopLogo = '';

                        if (salon is Map) {
                          salonLat = (salon['latitude'] ?? 0.0) as double;
                          salonLng = (salon['longitude'] ?? 0.0) as double;
                          shopName = salon['shopName'] ?? 'Salon';
                          shopAddress = salon['shopAddress'] ?? '';
                          salonUserId = salon['userId'] ?? salon['id'] ?? '';
                          shopLogo = salon['shopLogo'] ?? '';
                        } else {
                          salonLat = salon.latitude ?? 0.0;
                          salonLng = salon.longitude ?? 0.0;
                          shopName = salon.shopName ?? 'Salon';
                          shopAddress = salon.shopAddress ?? '';
                          salonUserId = salon.userId ?? salon.id ?? '';
                          shopLogo = salon.shopLogo ?? '';
                        }

                        if (salonLat != 0.0 && salonLng != 0.0) {
                          final markerId = MarkerId('salon_$salonUserId');

                          // Create custom marker with shop logo
                          final customIcon = shopLogo.isNotEmpty
                              ? await _createMarkerFromLogo(
                                  imageUrl: shopLogo, size: 100)
                              : BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueRed);

                          newMarkers.add(
                            Marker(
                              markerId: markerId,
                              position: LatLng(salonLat, salonLng),
                              icon: customIcon,
                              infoWindow: InfoWindow(
                                title: shopName,
                                snippet: shopAddress,
                              ),
                              onTap: isFromShopProfile
                                  ? null
                                  : () {
                                      _showSalonBottomSheet(
                                          salon is Map<String, dynamic>
                                              ? salon
                                              : _salonToMap(salon));
                                    },
                            ),
                          );
                        }
                      }

                      // Update markers in one operation to avoid flickering
                      // Only clear if markers haven't been initialized yet
                      if (!_markersInitialized) {
                        mapController.markers.clear();
                      }
                      mapController.markers.addAll(newMarkers);
                      _markersInitialized = true; // Mark as initialized

                      // Fit bounds after markers are set (but don't animate if already close)
                      await Future.delayed(const Duration(milliseconds: 300));
                      // Only fit bounds if we have multiple markers
                      if (newMarkers.length > 1) {
                        mapController.fitBoundsToMarkers();
                      } else if (newMarkers.isNotEmpty) {
                        // For single marker, just center on it without animation if already close
                        final marker = newMarkers.first;
                        final currentTarget =
                            mapController.cameraPosition.value.target;
                        final distance =
                            (currentTarget.latitude - marker.position.latitude)
                                    .abs() +
                                (currentTarget.longitude -
                                        marker.position.longitude)
                                    .abs();

                        if (distance > 0.01) {
                          final cameraPosition = CameraPosition(
                            target: marker.position,
                            zoom: 15,
                          );
                          mapController.cameraPosition.value = cameraPosition;
                          await controller.animateCamera(
                            CameraUpdate.newCameraPosition(cameraPosition),
                          );
                        }
                      }

                      // Show info window for first salon when from MapView
                      if (!isFromShopProfile && nearbySalons!.isNotEmpty) {
                        final firstSalon = nearbySalons!.first;
                        String salonUserId = '';

                        if (firstSalon is Map) {
                          salonUserId =
                              firstSalon['userId'] ?? firstSalon['id'] ?? '';
                        } else {
                          salonUserId =
                              firstSalon.userId ?? firstSalon.id ?? '';
                        }

                        await Future.delayed(const Duration(milliseconds: 400));
                        try {
                          controller.showMarkerInfoWindow(
                              MarkerId('salon_$salonUserId'));
                        } catch (e) {
                          debugPrint('Error showing info window: $e');
                        }
                      }
                    }
                  } else if (mapController.latitude != null &&
                      mapController.longitude != null) {
                    // If we have lat/lng but no salons list, add a marker for the location
                    final lat = mapController.latitude!;
                    final lng = mapController.longitude!;

                    final cameraPosition = CameraPosition(
                      target: LatLng(lat, lng),
                      zoom: 15,
                    );

                    // Set camera position first
                    mapController.cameraPosition.value = cameraPosition;

                    // Clear and add marker in one operation
                    mapController.markers.clear();
                    mapController.markers.add(
                      Marker(
                        markerId: const MarkerId('location_marker'),
                        position: LatLng(lat, lng),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed),
                        infoWindow: const InfoWindow(
                          title: 'Location',
                        ),
                      ),
                    );

                    // Animate camera once
                    await controller.animateCamera(
                      CameraUpdate.newCameraPosition(cameraPosition),
                    );

                    // Show info window after animation
                    await Future.delayed(const Duration(milliseconds: 300));
                    try {
                      controller.showMarkerInfoWindow(
                          const MarkerId('location_marker'));
                    } catch (e) {
                      debugPrint('Error showing info window: $e');
                    }
                  }
                },
                markers: mapController.markers.toSet(),
                myLocationEnabled: !showNearbySalons,
                myLocationButtonEnabled:
                    false, // Disabled - using custom FAB button instead
                zoomControlsEnabled: false,
                onTap: (LatLng position) {
                  if (!showNearbySalons) {
                    // When not showing nearby salons, allow location selection
                    mapController.onMapTap(position);
                    searchController.text =
                        mapController.selectedLocation.value?['address'] ??
                            'San Francisco';
                    mapController.setIsClean(true);
                  }
                  // When showing nearby salons, map tap doesn't do anything
                  // User can use search bar to find addresses
                },
              );
            }),
            // Show search field for address search (always visible)
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
                        color: AppColors.black,
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
                                color: AppColors.black,
                              ),
                              onPressed: () {
                                searchController.clear();
                                if (!showNearbySalons) {
                                  mapController.clearSelectedLocation();
                                }
                                mapController.suggestions.clear();
                                mapController.setIsClean(false);
                              },
                            )
                          : null,
                      hintText: 'Search address'.tr,
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
                      margin: const EdgeInsets.only(top: 8),
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
                            onTap: () async {
                              searchController.text = suggestion;
                              await mapController.searchPlaceById(
                                mapController.suggestions[index]['place_id'],
                              );
                              mapController.setIsClean(true);
                              mapController.suggestions.clear();
                              // Update search field with the selected address
                              if (mapController.selectedLocation.value !=
                                  null) {
                                searchController.text = mapController
                                        .selectedLocation.value!['address'] ??
                                    suggestion;
                              }
                            },
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            // Show "Get Current Location" button when not showing nearby salons (for signup)
            if (!showNearbySalons)
              Positioned(
                bottom: 100,
                right: 30,
                child: FloatingActionButton(
                  onPressed: () async {
                    // Get current location and set it as selected
                    await mapController.getUserLocation();
                    // Update search field with the selected address
                    if (mapController.selectedLocation.value != null) {
                      searchController.text =
                          mapController.selectedLocation.value!['address'] ??
                              '';
                    }
                  },
                  backgroundColor: AppColors.app,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                ),
              ),
            // Only show continue button if not showing nearby salons
            if (!showNearbySalons)
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
                              // Check for returnData in both Get.arguments and GoRouter extra
                              final extra = GoRouter.of(context).state.extra;
                              final returnData = (extra is Map &&
                                      extra['returnData'] == true) ||
                                  (Get.arguments != null &&
                                      Get.arguments['returnData'] == true);

                              if (returnData) {
                                // Return location data to previous screen using GoRouter
                                context
                                    .pop(mapController.selectedLocation.value);
                              } else {
                                // Default behavior (if any)
                                // mapController.updateContractorData();
                              }
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

  void _navigateToSalonProfile(
      String salonUserId, String shopName, String shopAddress) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    if (extra is Map) {
      userRole = extra['userRole'] as UserRole?;
    }

    if (userRole != null) {
      AppRouter.route.pushNamed(
        RoutePath.shopProfileScreen,
        extra: {
          'userRole': userRole,
          'userId': salonUserId,
          'controller': Get.find<UserHomeController>(),
        },
      );
    }
  }

  /// Convert salon object to Map
  Map<String, dynamic> _salonToMap(dynamic salon) {
    return {
      'userId': salon.userId ?? '',
      'shopName': salon.shopName ?? 'Salon',
      'shopAddress': salon.shopAddress ?? '',
      'shopLogo': salon.shopLogo ?? '',
      'shopImages': salon.shopImages ?? [],
      'latitude': salon.latitude ?? 0.0,
      'longitude': salon.longitude ?? 0.0,
      'avgRating': salon.avgRating ?? 0.0,
      'ratingCount': salon.ratingCount ?? 0,
      'totalQueueCount': salon.totalQueueCount ?? 0,
      'totalAvailableBarbers': salon.totalAvailableBarbers ?? 0,
      'isOpen': salon.isOpen ?? false,
      'shopStatus': salon.shopStatus ?? '',
      'statusReason': salon.statusReason ?? '',
      'phoneNumber': salon.phoneNumber ?? '',
      'email': salon.email ?? '',
      'distance': salon.distance ?? 0,
      'isFavorite': salon.isFavorite ?? false,
      'todayWorkingHours': salon.todayWorkingHours != null
          ? {
              'openingTime': salon.todayWorkingHours!.openingTime,
              'closingTime': salon.todayWorkingHours!.closingTime,
            }
          : null,
    };
  }

  /// Show salon details bottom sheet
  void _showSalonBottomSheet(Map<String, dynamic> salonData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSalonBottomSheet(salonData),
    );
  }

  Widget _buildSalonBottomSheet(Map<String, dynamic> salonData) {
    final shopName = salonData['shopName'] ?? 'Salon';
    final shopAddress = salonData['shopAddress'] ?? '';
    final queueCount = salonData['totalQueueCount'] ?? 0;
    final shopLogo = salonData['shopLogo'] ?? '';
    final shopImages = (salonData['shopImages'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final avgRating = (salonData['avgRating'] ?? 0.0) as double;
    final ratingCount = salonData['ratingCount'] ?? 0;
    final salonUserId = salonData['userId'] ?? '';
    final availableBarbers = salonData['totalAvailableBarbers'] ?? 0;
    final isOpen = salonData['isOpen'] ?? false;
    final phoneNumber = salonData['phoneNumber'] ?? '';
    final email = salonData['email'] ?? '';
    final distance = salonData['distance'] ?? 0;
    final statusReason = salonData['statusReason'] ?? '';
    final todayWorkingHours =
        salonData['todayWorkingHours'] as Map<String, dynamic>?;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop Logo and Name Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Shop Logo
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: CachedNetworkImage(
                              imageUrl: shopLogo,
                              width: 100.w,
                              height: 100.h,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                width: 100.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  color: AppColors.gray300,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Icon(Icons.store,
                                    size: 50.sp, color: AppColors.white50),
                              ),
                              placeholder: (context, url) => Container(
                                width: 100.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  color: AppColors.gray300,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.secondary),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          // Shop Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: shopName,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                                SizedBox(height: 8.h),
                                // Rating
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        size: 20.sp, color: Colors.amber),
                                    SizedBox(width: 4.w),
                                    CustomText(
                                      text: avgRating.toStringAsFixed(1),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                    SizedBox(width: 4.w),
                                    CustomText(
                                      text: '($ratingCount)',
                                      fontSize: 14.sp,
                                      color: AppColors.gray300,
                                    ),
                                    SizedBox(width: 8.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: isOpen
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.red.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        border: Border.all(
                                          color: isOpen
                                              ? Colors.green
                                              : Colors.red,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 8.w,
                                            height: 8.w,
                                            decoration: BoxDecoration(
                                              color: isOpen
                                                  ? Colors.green
                                                  : Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          CustomText(
                                            text: isOpen ? 'Open' : 'Closed',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: isOpen
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                // Status Badge and Favorite Button
                                Row(
                                  children: [
                                    if (statusReason.isNotEmpty && !isOpen) ...[
                                      Icon(Icons.error,
                                          size: 16.sp, color: Colors.red),
                                      SizedBox(width: 8.w),
                                      CustomText(
                                        text: statusReason,
                                        fontSize: 11.sp,
                                        color: Colors.red,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                    SizedBox(width: 8.w),
                                    // Favorite Button
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     // Toggle favorite
                                    //     try {
                                    //       final homeController = Get.find<UserHomeController>();
                                    //       final salonIndex = homeController.nearbySaloons.indexWhere((s) => s.userId == salonUserId);
                                    //       if (salonIndex != -1) {
                                    //         homeController.toggleFavoriteSalon(
                                    //           tag: tags.nearby,
                                    //           salonId: salonUserId,
                                    //           isFavorite: isFavorite,
                                    //           index: salonIndex,
                                    //         );
                                    //       }
                                    //     } catch (e) {
                                    //       debugPrint('Error toggling favorite: $e');
                                    //     }
                                    //   },
                                    //   // child: Container(
                                    //   //   padding: EdgeInsets.all(8.w),
                                    //   //   decoration: BoxDecoration(
                                    //   //     color: isFavorite ? Colors.red.withOpacity(0.1) : AppColors.gray300.withOpacity(0.3),
                                    //   //     shape: BoxShape.circle,
                                    //   //   ),
                                    //   //   child: Icon(
                                    //   //     Icons.favorite,
                                    //   //     size: 20.sp,
                                    //   //     color: isFavorite ? Colors.red : AppColors.gray300,
                                    //   //   ),
                                    //   // ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // Location Section
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 20.sp, color: AppColors.secondary),
                          SizedBox(width: 8.w),
                          CustomText(
                            text: shopAddress,
                            fontSize: 14.sp,
                            color: AppColors.black,
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // Info Cards Row
                      Row(
                        children: [
                          // Queue Count Card
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.people,
                                      size: 28.sp, color: Colors.red),
                                  SizedBox(height: 8.h),
                                  CustomText(
                                    text: queueCount.toString(),
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                  SizedBox(height: 4.h),
                                  CustomText(
                                    text: 'Queue',
                                    fontSize: 12.sp,
                                    color: AppColors.gray300,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Available Barbers Card
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.secondary.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.content_cut,
                                      size: 28.sp, color: AppColors.secondary),
                                  SizedBox(height: 8.h),
                                  CustomText(
                                    text: availableBarbers.toString(),
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondary,
                                  ),
                                  SizedBox(height: 4.h),
                                  CustomText(
                                    text: 'Barbers',
                                    fontSize: 12.sp,
                                    color: AppColors.gray300,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Distance Card
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.directions,
                                      size: 28.sp, color: Colors.blue),
                                  SizedBox(height: 8.h),
                                  CustomText(
                                    text: '${distance.toStringAsFixed(1)} km',
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 4.h),
                                  CustomText(
                                    text: 'Distance',
                                    fontSize: 12.sp,
                                    color: AppColors.gray300,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Working Hours
                      if (todayWorkingHours != null &&
                          (todayWorkingHours['openingTime'] != null ||
                              todayWorkingHours['closingTime'] != null))
                        Padding(
                          padding: EdgeInsets.only(top: 24.h),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.gray300.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 20.sp, color: AppColors.black),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'Working Hours',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                      ),
                                      SizedBox(height: 4.h),
                                      CustomText(
                                        text: todayWorkingHours[
                                                        'openingTime'] !=
                                                    null &&
                                                todayWorkingHours[
                                                        'closingTime'] !=
                                                    null
                                            ? '${todayWorkingHours['openingTime']} - ${todayWorkingHours['closingTime']}'
                                            : 'Not available',
                                        fontSize: 13.sp,
                                        color: AppColors.gray300,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Shop Images Gallery
                      if (shopImages.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 24.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Gallery',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                              SizedBox(height: 12.h),
                              SizedBox(
                                height: 120.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: shopImages.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 12.w),
                                      width: 120.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        border: Border.all(
                                          color: AppColors.gray300
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        child: CachedNetworkImage(
                                          imageUrl: shopImages[index],
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: AppColors.gray300,
                                            child: Icon(Icons.image,
                                                color: AppColors.white50,
                                                size: 40.sp),
                                          ),
                                          placeholder: (context, url) =>
                                              Container(
                                            color: AppColors.gray300,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                  color: AppColors.secondary),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Contact Information
                      if (phoneNumber.isNotEmpty || email.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 24.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Contact Information',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                              SizedBox(height: 12.h),
                              if (phoneNumber.isNotEmpty)
                                GestureDetector(
                                  onTap: () async {
                                    final Uri phoneUri =
                                        Uri.parse('tel:$phoneNumber');
                                    try {
                                      if (await canLaunchUrl(phoneUri)) {
                                        await launchUrl(phoneUri);
                                      } else {
                                        debugPrint(
                                            'Could not launch $phoneUri');
                                      }
                                    } catch (e) {
                                      debugPrint('Error launching phone: $e');
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.phone,
                                          size: 20.sp,
                                          color: AppColors.secondary),
                                      SizedBox(width: 12.w),
                                      CustomText(
                                        text: phoneNumber,
                                        fontSize: 14.sp,
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 12.h),
                              if (email.isNotEmpty)
                                Row(
                                  children: [
                                    Icon(Icons.email,
                                        size: 20.sp,
                                        color: AppColors.secondary),
                                    SizedBox(width: 12.w),
                                    CustomText(
                                      text: email,
                                      fontSize: 14.sp,
                                      color: AppColors.black,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                      SizedBox(height: 24.h),

                      // View Details Button
                      CustomButton(
                        onTap: () {
                          Navigator.pop(context);
                          _navigateToSalonProfile(
                              salonUserId, shopName, shopAddress);
                        },
                        title: "View Details",
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
