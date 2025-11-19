import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double appBarHeight;
  final double? appBarWidth;
  final Color appBarBgColor;
  final String? appBarContent;
  final IconData? iconData;
  final bool isIcon;
  final bool add;
  final VoidCallback? onTap;
  final VoidCallback? onTapAdd;

  const CustomAppBar({
    this.appBarHeight = 64,
    this.appBarWidth,
    this.appBarBgColor = AppColors.normalHover,
    this.appBarContent,
    super.key,
    this.iconData,
    this.isIcon = false,
    this.onTap,
    this.add = false,
    this.onTapAdd, // Default to false
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
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Centered Title
            if (widget.appBarContent != null)
              Center(
                child: CustomText(
                  text: widget.appBarContent!,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: AppColors.black,
                ),
              ),
            // Leading Icon (left)
            if (widget.iconData != null)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(widget.iconData),
                  color: AppColors.black,
                  onPressed: () {
                    if (widget.onTap != null) {
                      widget.onTap!();
                    } else {
                      context.pop();
                    }
                  },
                ),
              ),
            // Edit Icon (right)
            if (widget.isIcon)
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: Assets.icons.edit.svg(
                    colorFilter: const ColorFilter.mode(
                        AppColors.black, BlendMode.srcIn),
                  ),
                ),
              ),
            // Add Icon (right, after edit icon)
            if (widget.add)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: widget.isIcon ? 40.0 : 0.0),
                  child: GestureDetector(
                    onTap: widget.onTapAdd,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: AppColors.orange700),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
