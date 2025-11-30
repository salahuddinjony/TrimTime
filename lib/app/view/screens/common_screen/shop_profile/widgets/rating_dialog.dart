import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class RatingDialog {
  static void showRatingDialog<T>(BuildContext context,
      {String? saloonId,
      String? barberId,
      String? bookingId,
      T? controller,
      UserRole? userRole}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final ctrl = controller as dynamic;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.orange.shade50,
          title: Column(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.orange,
                size: 60.r,
              ),
              SizedBox(height: 10.h),
              const Text(
                "Give rating out of 5!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10.h),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                // allowHalfRating: true,
                itemSize: 30,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  ctrl.rating.value = rating;
                  print("Rating: $rating");
                },
              ),
            ],
          ),
          content: SizedBox(
            width: 500.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Text(
                    ctrl.imagePaths.isEmpty
                        ? "Add pictures (optional)"
                        : "${ctrl.imagePaths.length} picture(s) added",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: ctrl.imagePaths.isNotEmpty
                              ? List.generate(ctrl.imagePaths.length, (index) {
                                  return Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              ctrl.imagePaths[index],
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: -2,
                                            right: -2,
                                            child: Container(
                                              height: 24,
                                              width: 24,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  ctrl.removeImage(index);
                                                },
                                                iconSize: 20,
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                              : [],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            print("Add picture clicked");
                            ctrl.pickImages();
                          },
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write your feedback',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final resutl = await ctrl.giveRating(
                  barberId: barberId ?? "",
                  saloonOwnerId: saloonId ?? "",
                  bookingId: bookingId ?? "",
                );
                if (resutl) {
                  Navigator.of(context).pop();
                  controller.fetchCustomerReviews();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
