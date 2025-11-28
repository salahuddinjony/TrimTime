import 'dart:io';

import 'package:flutter/material.dart';

class CustomVideoThumbnail extends StatelessWidget {
  final String thumbnailPath;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const CustomVideoThumbnail({
    super.key,
    required this.thumbnailPath,
    required this.height,
    required this.width,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: borderRadius,
          child: Image.file(
            File(thumbnailPath),
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(6.0),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

