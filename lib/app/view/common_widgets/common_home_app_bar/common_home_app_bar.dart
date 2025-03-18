
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonHomeAppBar extends StatelessWidget {
  const CommonHomeAppBar({
    super.key,
    required this.scaffoldKey,
    required this.name,
    required this.image,
    required this.onTap,
    required, this.onSearch, this.isSearch
  });

  final String name;
  final VoidCallback onTap;
  final String image;
  final VoidCallback? onSearch ;
  final bool? isSearch;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColors.linearFirst,
      margin: EdgeInsets.only(
        top: 32.h,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
      child: Column(
        children: [
          ///====================================Top Section================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ///==================== Profile image =====================
                  CustomNetworkImage(
                      backgroundColor: Colors.white,
                      boxShape: BoxShape.circle,
                      imageUrl: image,
                      height: 46,
                      width: 46),

                  SizedBox(
                    width: 16.w,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: 'Welcome Back!',
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                        fontSize: 14,
                      ),

                      ///=====================user name =======================
                      CustomText(
                        text: name,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColors.black,
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                width: 65.w,
              ),

              ///==========================Notification button ====================
              IconButton(
                  onPressed: onTap, icon: const Icon(Icons.notification_add))
            ],
          ),
          SizedBox(
            height: 20.h,
          ),

          ///====================================Top Section================================

          isSearch == true?
           CustomTextField(
            onTap: onSearch,
            readOnly: true,
            fieldBorderColor: AppColors.black,
            fillColor: AppColors.linearFirst,
            hintText: AppStrings.searchSaloons,
            suffixIcon: const Icon(Icons.search),
          ):const SizedBox()
        ],
      ),
    );
  }
}
