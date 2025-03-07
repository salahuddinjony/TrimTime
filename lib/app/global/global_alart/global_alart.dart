// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class GlobalAlert {
// //Delete Dialog
//   static showDeleteDialog(
//       BuildContext context, VoidCallback onConfirm, String title) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(AppStrings.confirmDelete.tr),
//           content: Text(title),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text(AppStrings.cancel.tr,
//                   style: const TextStyle(color: Colors.grey)),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 onConfirm();
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.addedColor),
//               child: Text(AppStrings.delete.tr),
//             ),
//           ],
//         );
//       },
//     );
//   } //Delete Dialog
//
//   //Single Task Dialog
//   static void singleTaskDialog(BuildContext context, String title,
//       String assignedTo, String recurrence, String startDate, String startTime, String endDate, String endTime) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Center(
//             child: Text(
//               AppStrings.taskScheduleDetails.tr,
//               style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: AppColors.dark300),
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildDetailRow(AppStrings.task.tr, title),
//               _buildDetailRow(AppStrings.assignToColon.tr, assignedTo),
//               _buildDetailRow(AppStrings.recurrenceColon.tr, recurrence),
//               _buildDetailRow("Start Date".tr, startDate),
//               _buildDetailRow("Start Time".tr, startTime),
//               _buildDetailRow("End Date".tr, endDate),
//               _buildDetailRow("End TIme".tr, endTime),
//
//             ],
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Get.back(),
//               child: const Text(
//                 "Close",
//                 style: TextStyle(
//                     color: AppColors.blue900, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   static Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomText(
//             text: label,
//             textAlign: TextAlign.start,
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//             color: AppColors.dark300,
//             left: 8,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: CustomText(
//               textAlign: TextAlign.start,
//               text: value,
//               fontWeight: FontWeight.w500,
//               fontSize: 16,
//               color: AppColors.dark300,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
// }
