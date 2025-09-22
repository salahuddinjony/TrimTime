import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final bool isFile;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.child,
    this.colorFilter,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.isFile = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isFile && imageUrl.isNotEmpty) {
      final file = File(imageUrl);
      final exists = file.existsSync();
      if (exists) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: border,
            borderRadius: borderRadius,
            shape: boxShape,
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
              colorFilter: colorFilter,
            ),
          ),
          child: child,
        );
      }
      // fall through to network loader if file doesn't exist
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          shape: boxShape,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter: colorFilter,
          ),
        ),
        child: child,
      ),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.withValues(alpha: .6),
        highlightColor: Colors.grey.withValues(alpha: .3),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: border,
            color: backgroundColor , // Default to white for placeholder
            borderRadius: borderRadius,
            shape: boxShape,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor , // Red for error
          borderRadius: borderRadius,
          shape: boxShape,
        ),
        child: const Icon(Icons.error),
      ),
    );
  }
}
