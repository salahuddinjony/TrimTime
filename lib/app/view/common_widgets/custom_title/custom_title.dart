import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onActionTap;
  final Color titleColor;
  final Color actionColor;

  const CustomTitle({
    super.key,
    required this.title,
    required this.actionText,
    this.onActionTap,
    this.titleColor = Colors.black,
    this.actionColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: titleColor,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: actionColor,
            ),
          ),
        ),
      ],
    );
  }
}
