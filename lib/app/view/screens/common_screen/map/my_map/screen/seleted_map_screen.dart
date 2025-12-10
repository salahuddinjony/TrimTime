import 'dart:ui' as ui;
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/screens/common_screen/map/my_map/controller/map_controller.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
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
  List<dynamic>? nearbySalons;
  bool showNearbySalons = false;
  String? selectedSalonId;
  Map<String, dynamic>? selectedSalonData;
  GoogleMapController? googleMapController;
  String? currentSelectedMarkerId;
  Map<String, dynamic>? clickedSalonData; // Store clicked salon data for bottom card
  bool _markersInitialized = false; // Track if markers have been initialized
  bool _isLoadingSalonData = false; // Track loading state for salon details

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
    if (showNearbySalons && mapController.latitude == null && mapController.longitude == null) {
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

  /// Create custom marker icon with queue count badge
  Future<BitmapDescriptor> _createMarkerWithQueue({
    required Color markerColor,
    required int queueCount,
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final size = Size(180, 180); // Much larger size
    
    // Draw marker pin (bottom part) - much larger
    final pinPath = Path();
    pinPath.moveTo(size.width / 2, size.height);
    pinPath.lineTo(size.width / 2 - 40, size.height - 55);
    pinPath.arcToPoint(
      Offset(size.width / 2 + 40, size.height - 55),
      radius: const Radius.circular(25),
      clockwise: false,
    );
    pinPath.close();
    
    // Draw shadow for pin
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final shadowPath = Path()
      ..moveTo(size.width / 2 + 4, size.height + 4)
      ..lineTo(size.width / 2 - 40 + 4, size.height - 55 + 4)
      ..arcToPoint(
        Offset(size.width / 2 + 40 + 4, size.height - 55 + 4),
        radius: const Radius.circular(25),
        clockwise: false,
      )
      ..close();
    canvas.drawPath(
      shadowPath,
      shadowPaint,
    );
    
    // Draw pin
    final pinPaint = Paint()
      ..color = markerColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(pinPath, pinPaint);
    
    // Draw white border for pin
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawPath(pinPath, borderPaint);
    
    // Draw circular badge at top - even larger
    final badgeCenter = Offset(size.width / 2, 70);
    final badgeRadius = 70.0; // Much larger badge container
    
    // Badge shadow
    canvas.drawCircle(
      badgeCenter + const Offset(4, 4),
      badgeRadius,
      shadowPaint,
    );
    
    // Badge background (white circle)
    final badgePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(badgeCenter, badgeRadius, badgePaint);
    
    // Badge border
    final badgeBorderPaint = Paint()
      ..color = markerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(badgeCenter, badgeRadius, badgeBorderPaint);
    
    // Draw location icon - larger
    final iconData = Icons.location_on;
    final iconSize = 40.0;
    final iconTextPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: iconData.fontFamily,
          color: markerColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconTextPainter.layout();
    
    // Draw location icon at top of badge
    iconTextPainter.paint(
      canvas,
      Offset(
        badgeCenter.dx - iconTextPainter.width / 2,
        badgeCenter.dy - iconTextPainter.height / 2 - 18,
      ),
    );
    
    // Draw queue count text in red color below the icon - much larger
    final textPainter = TextPainter(
      text: TextSpan(
        text: queueCount.toString(),
        style: TextStyle(
          color: Colors.red,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        badgeCenter.dx - textPainter.width / 2,
        badgeCenter.dy - textPainter.height / 2 + 18,
      ),
    );
    
    // Convert to image
    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.width.toInt(), size.height.toInt());
    
    // Convert to byte data
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final uint8List = byteData!.buffer.asUint8List();
    
    return BitmapDescriptor.fromBytes(uint8List);
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
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
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
              CameraPosition initialPosition = mapController.cameraPosition.value;
              
              // If we have a specific salon location, use it for initial position
              // This prevents the map from starting at default location and then jumping
              if (mapController.latitude != null && mapController.longitude != null) {
                initialPosition = CameraPosition(
                  target: LatLng(mapController.latitude!, mapController.longitude!),
                  zoom: 15,
                );
              } else if (showNearbySalons && nearbySalons != null && nearbySalons!.isNotEmpty) {
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
                  if (!_markersInitialized && showNearbySalons && nearbySalons != null && nearbySalons!.isNotEmpty) {
                    // If we have a specific salon (from shop profile), add it as a marker
                    if (selectedSalonId != null && nearbySalons!.length == 1) {
                      final salon = nearbySalons![0];
                      double salonLat = 0.0;
                      double salonLng = 0.0;
                      String shopName = 'Salon';
                      String shopAddress = '';
                      
                      int queueCount = 0;
                      
                      if (salon is Map) {
                        salonLat = (salon['latitude'] ?? 0.0) as double;
                        salonLng = (salon['longitude'] ?? 0.0) as double;
                        shopName = salon['shopName'] ?? 'Salon';
                        shopAddress = salon['shopAddress'] ?? '';
                        queueCount = salon['queue'] is int ? salon['queue'] as int : (salon['queue'] is num ? (salon['queue'] as num).toInt() : 0);
                      } else {
                        salonLat = salon.latitude ?? 0.0;
                        salonLng = salon.longitude ?? 0.0;
                        shopName = salon.shopName ?? 'Salon';
                        shopAddress = salon.shopAddress ?? '';
                        queueCount = salon.queue ?? 0;
                      }
                      
                      debugPrint('Queue count for salon $shopName: $queueCount');
                      
                      if (salonLat != 0.0 && salonLng != 0.0) {
                        // Build info window snippet with queue count (always show)
                        String infoSnippet = '$shopAddress\nQueue: $queueCount';
                        
                        // Create custom marker with queue count
                        final customIcon = await _createMarkerWithQueue(
                          markerColor: Colors.red,
                          queueCount: queueCount,
                        );
                        
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
                              snippet: infoSnippet,
                            ),
                          ),
                        );
                        _markersInitialized = true; // Mark as initialized
                        
                        // Only animate camera if it's not already at the correct position
                        final currentTarget = mapController.cameraPosition.value.target;
                        final distance = (currentTarget.latitude - salonLat).abs() + (currentTarget.longitude - salonLng).abs();
                        
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
                        int queueCount = 0;
                        
                        if (salon is Map) {
                          salonLat = (salon['latitude'] ?? 0.0) as double;
                          salonLng = (salon['longitude'] ?? 0.0) as double;
                          shopName = salon['shopName'] ?? 'Salon';
                          shopAddress = salon['shopAddress'] ?? '';
                          salonUserId = salon['userId'] ?? salon['id'] ?? '';
                          queueCount = salon['queue'] is int ? salon['queue'] as int : (salon['queue'] is num ? (salon['queue'] as num).toInt() : 0);
                        } else {
                          salonLat = salon.latitude ?? 0.0;
                          salonLng = salon.longitude ?? 0.0;
                          shopName = salon.shopName ?? 'Salon';
                          shopAddress = salon.shopAddress ?? '';
                          salonUserId = salon.userId ?? salon.id ?? '';
                          queueCount = salon.queue ?? 0;
                        }
                        
                        debugPrint('Queue count for salon $shopName: $queueCount');
                        
                        if (salonLat != 0.0 && salonLng != 0.0) {
                          final markerId = MarkerId('salon_$salonUserId');
                          final isSelected = isFromShopProfile && selectedSalonId != null && salonUserId == selectedSalonId;
                          
                          // Build info window snippet with queue count (always show)
                          String infoSnippet = '$shopAddress\nQueue: $queueCount';
                          
                          // Create custom marker with queue count
                          final customIcon = await _createMarkerWithQueue(
                            markerColor: isSelected ? Colors.red : Colors.orange,
                            queueCount: queueCount,
                          );
                          
                          newMarkers.add(
                            Marker(
                              markerId: markerId,
                              position: LatLng(salonLat, salonLng),
                              icon: customIcon,
                              infoWindow: InfoWindow(
                                title: shopName,
                                snippet: infoSnippet,
                                onTap: isFromShopProfile ? null : () {
                                  _navigateToSalonProfile(salonUserId, shopName, shopAddress);
                                },
                              ),
                              onTap: isFromShopProfile ? null : () async {
                                // Set loading state and show card immediately
                                setState(() {
                                  _isLoadingSalonData = true;
                                  clickedSalonData = {
                                    'userId': salonUserId,
                                    'id': salon is Map ? (salon['id'] ?? '') : (salon.id ?? ''),
                                    'shopName': shopName,
                                    'shopAddress': shopAddress,
                                    'queue': queueCount,
                                    'latitude': salonLat,
                                    'longitude': salonLng,
                                    'shopLogo': salon is Map ? (salon['shopLogo'] ?? '') : (salon.shopLogo ?? ''),
                                    'avgRating': salon is Map ? (salon['avgRating'] ?? 0.0) : (salon.avgRating ?? 0.0),
                                    'ratingCount': salon is Map ? (salon['ratingCount'] ?? 0) : (salon.ratingCount ?? 0),
                                  };
                                });
                                
                                // Show info window
                                controller.showMarkerInfoWindow(markerId);
                                
                                // Simulate loading delay (you can replace this with actual data fetching if needed)
                                await Future.delayed(const Duration(milliseconds: 500));
                                
                                // Clear loading state
                                if (mounted) {
                                  setState(() {
                                    _isLoadingSalonData = false;
                                  });
                                }
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
                        final currentTarget = mapController.cameraPosition.value.target;
                        final distance = (currentTarget.latitude - marker.position.latitude).abs() + 
                                       (currentTarget.longitude - marker.position.longitude).abs();
                        
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
                          salonUserId = firstSalon['userId'] ?? firstSalon['id'] ?? '';
                        } else {
                          salonUserId = firstSalon.userId ?? firstSalon.id ?? '';
                        }
                        
                        await Future.delayed(const Duration(milliseconds: 400));
                        try {
                          controller.showMarkerInfoWindow(MarkerId('salon_$salonUserId'));
                        } catch (e) {
                          debugPrint('Error showing info window: $e');
                        }
                      }
                    }
                  } else if (mapController.latitude != null && mapController.longitude != null) {
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
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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
                      controller.showMarkerInfoWindow(const MarkerId('location_marker'));
                    } catch (e) {
                      debugPrint('Error showing info window: $e');
                    }
                  }
                },
                markers: mapController.markers.toSet(),
                myLocationEnabled: !showNearbySalons,
                myLocationButtonEnabled: false, // Disabled - using custom FAB button instead
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
                              if (mapController.selectedLocation.value != null) {
                                searchController.text = mapController.selectedLocation.value!['address'] ?? suggestion;
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
            // Show salon details card at bottom when clicking on marker (only from MapView)
            if (showNearbySalons && selectedSalonId == null && clickedSalonData != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildSalonDetailsCard(),
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
                      searchController.text = mapController.selectedLocation.value!['address'] ?? '';
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
                              final returnData = (extra is Map && extra['returnData'] == true) ||
                                  (Get.arguments != null && Get.arguments['returnData'] == true);
                              
                              if (returnData) {
                                // Return location data to previous screen using GoRouter
                                context.pop(mapController.selectedLocation.value);
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

  void _navigateToSalonProfile(String salonUserId, String shopName, String shopAddress) {
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

  Widget _buildSalonDetailsCard() {
    if (clickedSalonData == null) return const SizedBox.shrink();
    
    final shopName = clickedSalonData!['shopName'] ?? 'Salon';
    final shopAddress = clickedSalonData!['shopAddress'] ?? '';
    final queueCount = clickedSalonData!['queue'] ?? 0;
    final shopLogo = clickedSalonData!['shopLogo'] ?? '';
    final avgRating = clickedSalonData!['avgRating'] ?? 0.0;
    final ratingCount = clickedSalonData!['ratingCount'] ?? 0;
    final salonUserId = clickedSalonData!['userId'] ?? '';
    
    return Container(
      margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: _isLoadingSalonData
          ? Padding(
              padding: EdgeInsets.all(40.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          clickedSalonData = null;
                          _isLoadingSalonData = false;
                        });
                      },
                    ),
                  ),
                  // Loading indicator
                  const CircularProgressIndicator(),
                  SizedBox(height: 16.h),
                  CustomText(
                    text: 'Loading salon details...',
                    fontSize: 14.sp,
                    color: AppColors.gray300,
                  ),
                ],
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        clickedSalonData = null;
                        _isLoadingSalonData = false;
                      });
                    },
                  ),
                ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                // Salon logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CustomNetworkImage(
                    imageUrl: shopLogo,
                    width: 80.w,
                    height: 80.h,
                  ),
                ),
                SizedBox(width: 16.w),
                // Salon details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: shopName,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16.sp, color: AppColors.gray300),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: CustomText(
                              text: shopAddress,
                              fontSize: 14.sp,
                              color: AppColors.gray300,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          // Rating
                          Row(
                            children: [
                              Icon(Icons.star, size: 16.sp, color: Colors.amber),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: avgRating.toStringAsFixed(1),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: '($ratingCount)',
                                fontSize: 12.sp,
                                color: AppColors.gray300,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          SizedBox(width: 16.w),
                          // Queue count
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.people, size: 16.sp, color: Colors.red),
                                SizedBox(width: 4.w),
                                CustomText(
                                  text: 'Queue: $queueCount',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // View Details button
          Padding(
            padding: EdgeInsets.all(16.r),
            child: CustomButton(
              onTap: () {
                _navigateToSalonProfile(salonUserId, shopName, shopAddress);
              },
              title: "View Details".tr,
            ),
          ),
        ],
      ),
    );
  }
}
