import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;

  const StarRating({required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final stars = List<Widget>.generate(5, (index) {
      final starIndex = index + 1;
      IconData icon;
      Color color;
      if (rating >= starIndex) {
        icon = Icons.star;
        color = Colors.amber;
      } else {
        icon = Icons.star_border;
        color = Colors.grey;
      }
      return Icon(
        icon,
        size: size,
        color: color,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: .25),
            offset: const Offset(1, 2),
            blurRadius: 4,
          ),
        ],
      );
    });

    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}
