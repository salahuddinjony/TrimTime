
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double appBarHeight;
  final double? appBarWidth;
  final Color appBarBgColor;
  final String? appBarContent;
  final IconData? iconData;
  final bool isIcon;
  final VoidCallback? onTap;

  const CustomAppBar({
    this.appBarHeight = 64,
    this.appBarWidth,
    this.appBarBgColor = AppColors.white50,
    this.appBarContent,
    super.key,
    this.iconData,
    this.isIcon = false, this.onTap, // Default to false
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size(appBarWidth ?? double.infinity, appBarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.appBarBgColor,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            // Optional back button if iconData is provided
            if (widget.iconData != null)
              IconButton(
                icon: Icon(widget.iconData),
                color: AppColors.white50,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            // Display app bar content if provided
            if (widget.appBarContent != null)
              Expanded(
                child: CustomText(
                  text: widget.appBarContent!,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: AppColors.white50,
                ),
              ),

            // Conditionally display the icon based on isIcon
            if (widget.isIcon)
              GestureDetector(
                onTap: widget.onTap,
                child: Assets.icons.eye.svg(),
              ),
          ],
        ),
      ),
    );
  }
}
