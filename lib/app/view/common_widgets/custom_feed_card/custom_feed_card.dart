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
  final ValueChanged<bool> onFavoritePressed;
  final VoidCallback onVisitShopPressed;
  final bool? isVisitShopButton;
  final String? favoriteCount;
  final bool? isYouTubeVideo;
  final bool? isFavouriteFromApi;

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
    this.isVisitShopButton = false,
    this.favoriteCount,
    this.isYouTubeVideo = false,
    this.isFavouriteFromApi,
  });

  @override
  _CustomFeedCardState createState() => _CustomFeedCardState();
}

class _CustomFeedCardState extends State<CustomFeedCard> {
  late YoutubePlayerController _youtubeController;
  bool isYouTubeVideo = false;
  bool isFavorite = false;
  int favoriteCount = 0;

  @override
  void initState() {
    super.initState();

    // Check if postImageUrl is a YouTube video link
    isYouTubeVideo = widget.postImageUrl.contains("youtube.com") ||
        widget.postImageUrl.contains("youtu.be");

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

    // Initialize favorite state and count from widget
    isFavorite = widget.isFavouriteFromApi ?? false;
    favoriteCount = int.tryParse(widget.favoriteCount ?? "0") ?? 0;
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
          // ...existing code...
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

          Row(
            children: [
              // Favorite Button
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                    color: AppColors.secondary, shape: BoxShape.circle),
                child: IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Icon(Icons.favorite, color: Colors.red, size: 18),
                  SizedBox(width: 2.w),
                  Text(favoriteCount.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
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
              if (widget.isVisitShopButton != null &&
                  widget.isVisitShopButton!) ...[
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
              ]
            ],
          ),
        ],
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      if (isFavorite) {
        isFavorite = false;
        if (favoriteCount > 0) favoriteCount--;
      } else {
        isFavorite = true;
        favoriteCount++;
      }
    });
    widget.onFavoritePressed(isFavorite);
  }
}
