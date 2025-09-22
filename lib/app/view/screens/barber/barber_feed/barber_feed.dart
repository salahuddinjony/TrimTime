import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:barber_time/app/view/screens/barber/barber_feed/controller/barber_feed_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_feed/model/feed_model.dart';

class BarberFeed extends StatelessWidget {
  final bool isEdit;
  final FeedItem? item;
  final String? image;
  BarberFeed({
    super.key,
    this.item,
    required this.isEdit,
    this.image,
  });
  final BarberFeedController feedController = Get.find<BarberFeedController>();
  @override
  Widget build(BuildContext context) {
  // If editing, initialize the imagepath with the existing image URL.
  feedController.imagepath.value = image ?? '';
  // Mark whether the initial imagepath is a network URL so preview uses the
  // correct image provider (File vs Network). Also ensure cleared flag is
  // reset when opening the editor.
  feedController.isNetworkImage.value = (image != null && ((image?.startsWith('http') ?? false) || (image?.startsWith('https') ?? false)));
  feedController.clearedInitialImage.value = false;


    final extra = GoRouter.of(context).state.extra;
    // Determine user role whether passed directly or inside an extra map.
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map && extra['userRole'] is UserRole) {
      userRole = extra['userRole'] as UserRole;
    } else {
      userRole = null;
    }

    // Resolve the feed item to edit. It may come from the widget constructor
    // or from the GoRouter extra (map or direct FeedItem).
    FeedItem? feedItem = item;
    if (isEdit && feedItem == null) {
      if (extra is Map && extra['feedItem'] is FeedItem) {
        feedItem = extra['feedItem'] as FeedItem;
      } else if (extra is FeedItem) {
        feedItem = extra;
      }
    }

    final captionController = TextEditingController(text: feedItem?.caption ?? '');

    debugPrint("===================${userRole?.name}");
    if (!isEdit && userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        currentIndex: 2,
        role: userRole ?? UserRole.barber,
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.linearFirst,
        title: const Text(AppStrings.addFeed),
      ),
      body: Column(
        children: [
          ClipPath(
            clipper: CurvedBannerClipper(),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xCCEDC4AC), // First color (with opacity)
                    Color(0xFFE9874E),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => feedController.pickImage(),
                          child: Obx(() {
                            final picked = feedController.imagepath.value;
                            final isNetwork = feedController.isNetworkImage.value ||
                                (picked.startsWith('http') || picked.startsWith('https'));
                            return Stack(
                              children: [
                                // Show network image when the path is a URL.
                                if (picked.isNotEmpty && isNetwork)
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: CustomNetworkImage(
                                      imageUrl: picked,
                                      height: 150,
                                      width: 150,
                                    ),
                                  )
                                // If user selected a local image show it.
                                else if (picked.isNotEmpty && !isNetwork)
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Image.file(
                                      File(picked.toString()),
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                // If editing and there is an existing network image,
                                // show that when no new image is picked and the
                                // user hasn't explicitly cleared the initial image.
                                else if (isEdit && (feedItem?.images.isNotEmpty ?? false) && !feedController.clearedInitialImage.value)
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: CustomNetworkImage(
                                      imageUrl: image ?? feedItem!.images.first,
                                      height: 150,
                                      width: 150,
                                    ),
                                  )
                                else
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                        SizedBox(height: 8),
                                        CustomText(
                                          text: "Upload Image",
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (picked.isNotEmpty)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () => feedController.clearImage(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.6),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.w,
                    ),
                    const CustomText(
                      text: AppStrings.caption,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                      fontSize: 16,
                      bottom: 8,
                    ),
                    CustomTextField(
                      textEditingController: captionController,
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: 40.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: CustomButton(
              title: isEdit ? AppStrings.update : AppStrings.post,
              textColor: AppColors.white50,
              onTap: () async {

                if(isEdit){
                 final bool isUpdateSuccess = await feedController.updateFeed(
                    feedId: feedItem?.id ?? '',
                    caption: captionController.text,

                  );
                  if (isUpdateSuccess) {
                    // try {
                    //   if (Get.isRegistered<InfoController>()) {
                    //     await Get.find<InfoController>().getAllFeeds();
                    //   }
                    // } catch (e) {
                    //   debugPrint('Error refreshing owner feeds: $e');
                    // }
                    AppRouter.route.pushNamed(RoutePath.myFeed, extra: userRole);
                    return;
                  }
                  return;
                
                }
                final bool isCreateSuccess = await feedController.createFeed(
                    caption: captionController.text);
                // If editing, pass the edited FeedItem back; otherwise create new
              
                if (isCreateSuccess) {
                //  try {
                //    if (Get.isRegistered<InfoController>()) {
                //      await Get.find<InfoController>().getAllFeeds();
                //    }
                //  } catch (e) {
                //    debugPrint('Error refreshing owner feeds: $e');
                //  }
                  AppRouter.route.pushNamed(RoutePath.myFeed, extra: userRole);
                  return;
                }
              },
              fillColor: AppColors.black,
            ),
          )
        ],
      ),
    );
  }
}
