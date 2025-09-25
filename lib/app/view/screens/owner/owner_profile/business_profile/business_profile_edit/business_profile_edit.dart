import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

class BusinessProfileEdit extends StatelessWidget {
  const BusinessProfileEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD0A3), // soft peach background
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: "Shop Edit Profile",
        iconData: Icons.arrow_back,
      ),
      body: ClipPath(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Shop Pictures",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    buildImageTile(AppConstants.shop),
                    const SizedBox(width: 10),
                    buildImageTile(AppConstants.shop),
                    const SizedBox(width: 10),
                    buildAddTile(),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Add logo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.network(
                      AppConstants.demoImage,
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration( 
                        color: Colors.white.withValues(alpha: .3), 
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("Shop Name"),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: "Barber time",
                  decoration: inputDecoration(),
                ),
                const SizedBox(height: 20),
                const Text("Barber shop business bio"),
                const SizedBox(height: 8),
                TextFormField(
                  maxLines: 4,
                  decoration: inputDecoration(hintText: "Write your business bio"),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Gallery",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    if (index < 5) {
                      return SizedBox(
                        width: 80,
                        height: 50,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "${AppConstants.shop}${index + 1}.jpg",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 12,
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return buildAddTile();
                    }
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onTap: () {
                    context.pop();
                  },
                  title: AppStrings.save,
                  fillColor: Colors.black,
                  textColor: Colors.white,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageTile(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imagePath,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildAddTile() {
    return Container(
      width: 80,
      height: 80, // Changed from 50 to 80 to match image tiles
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.add, color: Colors.grey),
    );
  }

  InputDecoration inputDecoration({String hintText = ""}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
