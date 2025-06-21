
import 'package:flutter/material.dart';

void showGroomingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Experience Expert Grooming Like Never Before",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildPoint("Personalized Grooming", "Tailored haircuts, shaves, and grooming services for every client."),
              _buildPoint("Precision & Style", "Expertly crafted cuts to match your unique style and preferences."),
              _buildPoint("Classic & Modern Expertise", "Skilled in both timeless styles and the latest trends."),
              _buildPoint("Quality Tools, Perfect Results", "Using top-tier tools for a refined, polished look."),
              _buildPoint("Relax and Refresh", "A welcoming atmosphere to help you unwind and feel your best."),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildPoint(String title, String description) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_box, color: Colors.deepOrange),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(text: "$title ", style: const TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
