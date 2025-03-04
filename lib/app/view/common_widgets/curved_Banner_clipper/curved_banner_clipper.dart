import 'package:flutter/material.dart';

class CurvedBannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width/4, size.height-40, size.width /2, size.height -20);
    path.quadraticBezierTo(3/4*size.width, size.height, size.width, size.height -20);
    path.lineTo(size.width, 0);
    return path;

    //////////////////////////////////////////////////////////////////////////////////
    // double w = size.width;
    // double h = size.height/1.4;
    // final path = Path();
    // path.lineTo(0, h);
    // path.quadraticBezierTo(w / 4, h, w / 2, h - 50);
    // path.quadraticBezierTo(3* w/4, h-100, w, h - 50);
    //
    // path.lineTo(w, 0);
    // path.close();
    // return path;
    //////////////////////////////////////////////////////////////////////////////////
    // double w = size.width;
    // double h = size.height/2;
    // final path = Path();
    // path.lineTo(0, h-80);
    // path.quadraticBezierTo(w / 4, h, w / 2, h - 50);
    // path.quadraticBezierTo(3* w/4, h-100, w, h - 50);
    // path.lineTo(w, 0);
    // path.close();
    // return path;
    //////////////////////////////////////////////////////////////////////////////////
    // final path = Path();
    //
    // path.lineTo(0, 0);
    // path.lineTo(0, size.height - 100);
    //
    // // Adjust curve position
    // path.quadraticBezierTo(
    //   size.width / 2, size.height, // Curve control points
    //   size.width, size.height - 100,
    // );
    // path.lineTo(size.width, 0);
    // path.close();
    //
    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}