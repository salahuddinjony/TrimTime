// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:barber_time/app/utils/app_colors.dart';
// import 'package:barber_time/app/utils/app_strings.dart';
// import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
// import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
//
// class CustomFeedCard extends StatefulWidget {
//   final String userImageUrl;
//   final String userName;
//   final String userAddress;
//   final String postImageUrl; // This can be image or video
//   final String postText;
//   final String rating;
//   final VoidCallback onFavoritePressed;
//   final VoidCallback onVisitShopPressed;
//   final bool? isVisitSHopButton;
//
//   const CustomFeedCard({
//     super.key,
//     required this.userImageUrl,
//     required this.userName,
//     required this.userAddress,
//     required this.postImageUrl,
//     required this.postText,
//     required this.rating,
//     required this.onFavoritePressed,
//     required this.onVisitShopPressed,
//     this.isVisitSHopButton = false,
//   });
//
//   @override
//   _CustomFeedCardState createState() => _CustomFeedCardState();
// }
//
// class _CustomFeedCardState extends State<CustomFeedCard> {
//   bool isFavorite = false;
//   late VideoPlayerController _videoController;
//   bool isVideo = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Check if URL is video
//     isVideo = widget.postImageUrl.endsWith(".mp4") ||
//         widget.postImageUrl.endsWith(".mov") ||
//         widget.postImageUrl.endsWith(".avi");
//
//     if (isVideo) {
//       _videoController = VideoPlayerController.network(widget.postImageUrl)
//         ..initialize().then((_) {
//           setState(() {});
//           _videoController.setLooping(true);
//           _videoController.play(); // autoplay if needed
//         });
//     }
//   }
//
//   @override
//   void dispose() {
//     if (isVideo) {
//       _videoController.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // User Info Row
//           Row(
//             children: [
//               CustomNetworkImage(
//                 boxShape: BoxShape.circle,
//                 imageUrl: widget.userImageUrl,
//                 height: 48,
//                 width: 48,
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       left: 8,
//                       text: widget.userName,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 12,
//                       color: AppColors.black,
//                     ),
//                     CustomText(
//                       left: 8,
//                       text: widget.userAddress,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 12,
//                       color: AppColors.black,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10.h),
//
//           // Post Image or Video
//           isVideo
//               ? _videoController.value.isInitialized
//               ? AspectRatio(
//             aspectRatio: _videoController.value.aspectRatio,
//             child: VideoPlayer(_videoController),
//           )
//               : const Center(child: CircularProgressIndicator())
//               : CustomNetworkImage(
//             borderRadius: const BorderRadius.all(Radius.circular(12)),
//             imageUrl: widget.postImageUrl,
//             height: 364,
//             width: double.infinity,
//           ),
//
//           // Post Text
//           CustomText(
//             textAlign: TextAlign.start,
//             maxLines: 2,
//             top: 8,
//             text: widget.postText,
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//             color: AppColors.black,
//           ),
//
//           widget.isVisitSHopButton == true
//               ? const SizedBox()
//               : Row(
//             children: [
//               // Favorite Button
//               Container(
//                 margin: const EdgeInsets.only(top: 10),
//                 decoration: const BoxDecoration(
//                     color: AppColors.secondary, shape: BoxShape.circle),
//                 child: IconButton(
//                   onPressed: _toggleFavorite,
//                   icon: Icon(
//                     isFavorite ? Icons.favorite : Icons.favorite_border,
//                     color: isFavorite ? Colors.red : Colors.white,
//                   ),
//                 ),
//               ),
//               CustomText(
//                 textAlign: TextAlign.start,
//                 left: 8,
//                 text: widget.rating,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//                 color: AppColors.black,
//               ),
//               const Spacer(),
//               // Visit Shop Button
//               GestureDetector(
//                 onTap: widget.onVisitShopPressed,
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 10),
//                   padding: const EdgeInsets.all(5),
//                   decoration: const BoxDecoration(
//                     color: AppColors.black,
//                   ),
//                   child: const CustomText(
//                     textAlign: TextAlign.start,
//                     left: 8,
//                     text: AppStrings.visitShop,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 14,
//                     color: AppColors.white50,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _toggleFavorite() {
//     setState(() {
//       isFavorite = !isFavorite;
//     });
//     widget.onFavoritePressed();
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomFeedCard extends StatefulWidget {
  final String userImageUrl;
  final String userName;
  final String userAddress;
  final String postImageUrl; // YouTube URL or Image URL
  final String postText;
  final String rating;
  final VoidCallback onFavoritePressed;
  final VoidCallback onVisitShopPressed;
  final bool? isVisitSHopButton;

  const CustomFeedCard({
    super.key,
    required this.userImageUrl,
    required this.userName,
    required this.userAddress,
    required this.postImageUrl,
    required this.postText,
    required this.rating,
    required this.onFavoritePressed,
    required this.onVisitShopPressed,
    this.isVisitSHopButton = false,
  });

  @override
  _CustomFeedCardState createState() => _CustomFeedCardState();
}

class _CustomFeedCardState extends State<CustomFeedCard> {
  bool isFavorite = false;
  late YoutubePlayerController _youtubeController;
  bool isYouTubeVideo = false;

  @override
  void initState() {
    super.initState();

    // Check if postImageUrl is a YouTube video link
    isYouTubeVideo = widget.postImageUrl.contains("youtube.com") || widget.postImageUrl.contains("youtu.be");

    if (isYouTubeVideo) {
      final videoId = YoutubePlayer.convertUrlToId(widget.postImageUrl);
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,


        ),
      );
    }
  }

  @override
  void dispose() {
    if (isYouTubeVideo) {
      _youtubeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Row
          Row(
            children: [
              CustomNetworkImage(
                boxShape: BoxShape.circle,
                imageUrl: widget.userImageUrl,
                height: 48,
                width: 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      left: 8,
                      text: widget.userName,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.black,
                    ),
                    CustomText(
                      left: 8,
                      text: widget.userAddress,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Show YouTube Video Player or Image
          isYouTubeVideo
              ? YoutubePlayer(
            controller: _youtubeController,
            showVideoProgressIndicator: true,
            progressIndicatorColor: AppColors.secondary,
            onReady: () {
              // YouTube player ready
            },
          )
              : CustomNetworkImage(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            imageUrl: widget.postImageUrl,
            height: 364,
            width: double.infinity,
          ),

          // Post Text
          CustomText(
            textAlign: TextAlign.start,
            maxLines: 2,
            top: 8,
            text: widget.postText,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.black,
          ),

          widget.isVisitSHopButton == true
              ? const SizedBox()
              : Row(
            children: [
              // Favorite Button
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                child: IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                ),
              ),
              CustomText(
                textAlign: TextAlign.start,
                left: 8,
                text: widget.rating,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.black,
              ),
              const Spacer(),
              // Visit Shop Button
              GestureDetector(
                onTap: widget.onVisitShopPressed,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppColors.black,
                  ),
                  child: const CustomText(
                    textAlign: TextAlign.start,
                    left: 8,
                    text: AppStrings.visitShop,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.white50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    widget.onFavoritePressed();
  }
}
