import 'package:flutter/material.dart';

class CustomBookingButton extends StatelessWidget {
  final String text;
  final Color txColor;
  final double width;
  final double height;
  final IconData icon;
  final VoidCallback? onTap;
  final Color BgColor;
  final double fontSize;

  const CustomBookingButton(
      {super.key,
      this.text = "Book Now",
      this.BgColor = Colors.black,
      this.txColor = Colors.white,
      this.width = double.infinity,
      this.height = 48,
      this.icon = Icons.cut_sharp,
      this.onTap,
      this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: BgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: txColor),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: txColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
