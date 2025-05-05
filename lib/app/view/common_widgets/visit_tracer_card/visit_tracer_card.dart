import 'package:flutter/material.dart';

class VisitTracerCard extends StatelessWidget {
  final int currentStatus;
  final int totalStatus;
  final String title;
  final String description;

  const VisitTracerCard({super.key,
    required this.currentStatus,
    required this.totalStatus,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Circular Progress Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: currentStatus / totalStatus,
                  strokeWidth: 6.0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
                Text(
                  '$currentStatus / $totalStatus',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
            // Text Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


