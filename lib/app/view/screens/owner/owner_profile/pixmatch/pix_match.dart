import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import '../../../../../core/route_path.dart';
import '../../../../../core/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/enums/user_role.dart';
import '../../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import '../../../../common_widgets/common_shop_card/common_shop_card.dart';
import '../../../../common_widgets/custom_text/custom_text.dart';
import '../../../user/home/controller/user_home_controller.dart' show UserHomeController, tags;
import 'controller/pix_match_controller.dart';

class PixMatch extends StatefulWidget {
  const PixMatch({super.key});

  @override
  State<PixMatch> createState() => _PixMatchState();
}

class _PixMatchState extends State<PixMatch> with WidgetsBindingObserver {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  UserRole? userRole;
  late PixMatchController controller;
  bool _hasShownResults = false;
  bool _isShowingBottomSheet = false;
  bool _isInitialized = false;

  Future<void> _pickImage() async {
    // Show bottom sheet to choose between camera and gallery
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.black),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromSource(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.black),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromSource(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      // Show processing dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ProcessingDialog(imagePath: pickedFile.path),
      );

      // Call API to analyze salon with current location
      // Get location from UserHomeController (which gets it on app initialize) or PixMatchController
      double lat = 23.9323; // Default fallback
      double lng = 90.4170; // Default fallback
      
      try {
        final homeController = Get.find<UserHomeController>();
        lat = homeController.currentLatitude.value ?? controller.currentLatitude.value ?? lat;
        lng = homeController.currentLongitude.value ?? controller.currentLongitude.value ?? lng;
      } catch (e) {
        // UserHomeController not available, use PixMatchController's location
        lat = controller.currentLatitude.value ?? lat;
        lng = controller.currentLongitude.value ?? lng;
      }
      
      final response = await controller.analyzeSalon(
        imagePath: pickedFile.path,
        latitude: lat,
        longitude: lng,
      );

      if (!mounted) return;

      // Close the processing dialog
      Navigator.of(context).pop();

      // Show results in bottom sheet
      if (response != null && controller.analyzedSaloons.isNotEmpty) {
        _hasShownResults = true;
        _showResultsBottomSheet();
      } else {
        _showNoResultsDialog();
      }
    }
  }

  void _showNoResultsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('No Results Found'),
        content: const Text('We couldn\'t find any nearby salons matching your image.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showResultsBottomSheet() {
    if (_isShowingBottomSheet || !mounted) return; // Prevent showing multiple bottom sheets
    
    _isShowingBottomSheet = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: 'Found Salons',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.black,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Reset flag after a delay to allow the pop animation to complete
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (mounted) {
                            setState(() {
                              _isShowingBottomSheet = false;
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Salons list
              Expanded(
                child: Obx(() {
                  if (controller.analyzeStatus.value.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.app,
                      ),
                    );
                  } else if (controller.analyzedSaloons.isEmpty) {
                    return const Center(
                      child: CustomText(
                        text: 'No salons found',
                        color: AppColors.black,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: controller.analyzedSaloons.length,
                      itemBuilder: (context, index) {
                        final salon = controller.analyzedSaloons[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              // Reset flag after a delay to allow the pop animation to complete
                              Future.delayed(const Duration(milliseconds: 300), () {
                                if (mounted) {
                                  setState(() {
                                    _isShowingBottomSheet = false;
                                  });
                                }
                              });
                              // Navigate to shop profile
                              // When we return, didChangeDependencies will automatically show the bottom sheet again
                              try {
                                final homeController = Get.find<UserHomeController>();
                                AppRouter.route.pushNamed(
                                  RoutePath.shopProfileScreen,
                                  extra: {
                                    'userRole': userRole,
                                    'userId': salon.userId,
                                    'controller': homeController,
                                  },
                                );
                              } catch (e) {
                                // If UserHomeController is not found, navigate without it
                                AppRouter.route.pushNamed(
                                  RoutePath.shopProfileScreen,
                                  extra: {
                                    'userRole': userRole,
                                    'userId': salon.userId,
                                  },
                                );
                              }
                            },
                            child: CommonShopCard(
                              imageUrl: salon.shopLogo,
                              title: salon.shopName,
                              rating: "${salon.avgRating.toStringAsFixed(1)} ★",
                              location: salon.shopAddress,
                              discount: salon.distance.toString(),
                              isSaved: salon.isFavorite,
                              totalQueueCount: salon.totalQueueCount,
                              totalAvailableBarbers: salon.totalAvailableBarbers,
                              onSaved: () {
                                // Handle favorite toggle
                                try {
                                  final homeController = Get.find<UserHomeController>();
                                  final currentIndex = controller.analyzedSaloons.indexWhere(
                                    (s) => s.userId == salon.userId,
                                  );
                                  if (currentIndex >= 0) {
                                    homeController.toggleFavoriteSalon(
                                      tag: tags.searches,
                                      salonId: salon.userId,
                                      isFavorite: salon.isFavorite,
                                      index: currentIndex,
                                    );
                                    // Update local salon favorite status
                                    controller.analyzedSaloons[currentIndex].isFavorite =
                                        !controller.analyzedSaloons[currentIndex].isFavorite;
                                    controller.analyzedSaloons.refresh();
                                  }
                                } catch (e) {
                                  debugPrint('Error toggling favorite: $e');
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      // Reset flag when bottom sheet is dismissed (by drag, tap outside, or close button)
      if (mounted) {
        setState(() {
          _isShowingBottomSheet = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.put(PixMatchController());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userRole ??= GoRouter.of(context).state.extra as UserRole?;
    
    // Check if we should show bottom sheet when screen becomes visible again
    if (_isInitialized && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Small delay to ensure screen is fully visible after navigation
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            _checkAndShowBottomSheetIfNeeded();
          }
        });
      });
    }
    
    if (!_isInitialized) {
      _isInitialized = true;
    }
  }

  void _checkAndShowBottomSheetIfNeeded() {
    if (!mounted || _isShowingBottomSheet) return;
    
    // If we have results and haven't cleared them, show the bottom sheet
    if (_hasShownResults && controller.analyzedSaloons.isNotEmpty) {
      _showResultsBottomSheet();
    }
  }

  void _clearSelectedImage() {
    setState(() {
      _imageFile = null;
      _hasShownResults = false;
      _isShowingBottomSheet = false;
      // Clear search results
      controller.analyzedSaloons.clear();
      controller.analyzeStatus.value = RxStatus.empty();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && mounted) {
      // App resumed - check if we need to show bottom sheet
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _checkAndShowBottomSheetIfNeeded();
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Get.delete<PixMatchController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.searchScreenBg,
        title: const Text("Add Image"),
      ),
      body: Column(
        children: [
          ClipPath(
            clipper: CurvedBannerClipper(),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.searchScreenBg
                // gradient: LinearGradient(
                //   colors: [
                //     Color(0xCCEDC4AC),
                //     Color(0xFFE9874E),
                //   ],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CustomText(
                      text: AppStrings.choiceImage,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                      fontSize: 16,
                      bottom: 8,
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Center(
                          child: DottedBorder(
                            padding: const EdgeInsets.all(25),
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Column(
                                children: [
                                  _imageFile == null
                                      ? const Icon(Icons.add, color: Colors.white)
                                      : Image.file(
                                    File(_imageFile!.path),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  const CustomText(
                                    text: "Upload a current picture",
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black,
                                    fontSize: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Show options if image is selected
                    if (_imageFile != null) ...[
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Clear image button
                          OutlinedButton.icon(
                            onPressed: _clearSelectedImage,
                            icon: const Icon(Icons.delete_outline, size: 18),
                            label: const CustomText(
                              text: "Clear Image",
                              fontWeight: FontWeight.w500,
                              color: AppColors.red,
                              fontSize: 14,
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.red,
                              side: const BorderSide(color: AppColors.red, width: 1.5),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // View search results button (only if bottom sheet is closed and results exist)
                          if (!_isShowingBottomSheet && controller.analyzedSaloons.isNotEmpty)
                            ElevatedButton.icon(
                              onPressed: _showResultsBottomSheet,
                              icon: const Icon(Icons.visibility, size: 18),
                              label: CustomText(
                                text: "View Results (${controller.analyzedSaloons.length})",
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                                fontSize: 14,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.app,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                    SizedBox(height: 100.w),
                  ],
                ),
              ),
            ),
          ),
          // Uncomment below if you want a button for additional actions
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          //   child: CustomButton(
          //     title: AppStrings.post,
          //     textColor: AppColors.white50,
          //     onTap: () {},
          //     fillColor: AppColors.black,
          //   ),
          // )
        ],
      ),
    );
  }
}

class ProcessingDialog extends StatelessWidget {
  final String imagePath;

  const ProcessingDialog({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: AppColors.linearFirst,
            ),
            const SizedBox(height: 20),
            const Text(
              "Processing your image...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(imagePath),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
