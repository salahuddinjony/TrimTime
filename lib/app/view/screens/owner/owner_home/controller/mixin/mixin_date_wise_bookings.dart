import 'dart:convert';

import 'package:barber_time/app/global/helper/extension/extension.dart' as intl;
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/model/date_wise_booking_data/date_wise_booking_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin DateWiseBookingsMixin {
  final RxList<BookingData> dateWiseBookings = <BookingData>[].obs;
  Rx<RxStatus> dateWiseBookingsStatus = Rx<RxStatus>(RxStatus.empty());

  RxInt selectedIndex = 0.obs;

  final List<DateTime> dates = List.generate(
    28, // Generate dates for the next 28 days
    (index) => DateTime.now().add(Duration(days: index)),
  );

  debugPrintDates() {
    for (var date in dates) {
      debugPrint("Generated Date: ${date}");
    }
  }

  void goToNextDate({isDontCalled = false}) {
    if (selectedIndex.value < dates.length - 1) {
      selectedIndex.value++;
      if (!isDontCalled) {
        fetchDateWiseBookings(date: selectedDate.formatDateApi());
      }
      scrollToSelectedDate(selectedIndex.value);
    }
  }

  void goToPreviousDate({isDontCalled = false}) {
    if (selectedIndex.value > 0) {
      selectedIndex.value--;
      if (!isDontCalled) {
        fetchDateWiseBookings(date: selectedDate.formatDateApi());
      }
      scrollToSelectedDate(selectedIndex.value);
    }
  }

  // Getter for selected date based on selectedIndex
  DateTime get selectedDate => dates[selectedIndex.value];

  void selectDate(int index) {
    selectedIndex.value = index;
    scrollToSelectedDate(selectedIndex.value);
  }

  final ScrollController datePickerScrollController = ScrollController();

  void scrollToSelectedDate(int index) {
    final itemWidth = 60.0 + 12.0;
    final offset = (index * itemWidth) - (itemWidth * 2);
    datePickerScrollController.animateTo(
      offset < 0 ? 0 : offset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> fetchDateWiseBookings({String? date}) async {
    dateWiseBookingsStatus.value = RxStatus.loading();
    try {
      final response = await ApiClient.getData(
        ApiUrl.getDateWiseBookings,
        query: {
          'date': date ?? selectedDate.formatDateApi(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Raw Response Body Type: ${response.body.runtimeType}");
        debugPrint("Raw Response Body: ${response.body}");

        // Handle both String and Map responses
        final Map<String, dynamic> responseData;
        if (response.body is String) {
          responseData = jsonDecode(response.body) as Map<String, dynamic>;
        } else {
          responseData = response.body as Map<String, dynamic>;
        }

        debugPrint("Parsed Response Data Type: ${responseData.runtimeType}");
        debugPrint("Data field type: ${responseData['data']?.runtimeType}");
        debugPrint("Meta field type: ${responseData['meta']?.runtimeType}");

        final bookingDataList =
            DateWiseBookingDataResponse.fromJson(responseData);
        dateWiseBookings.value = bookingDataList.data;

        debugPrint("Date-wise bookings fetched successfully.");
        debugPrint("Number of bookings: ${dateWiseBookings.length}");

        if (dateWiseBookings.isEmpty) {
          dateWiseBookingsStatus.value = RxStatus.empty();
        } else {
          dateWiseBookingsStatus.value = RxStatus.success();
        }
      } else {
        debugPrint(
            "Failed to load date-wise bookings: ${response.statusCode} - ${response.statusText}");
        dateWiseBookingsStatus.value = RxStatus.error(
            'Failed to load date-wise bookings: ${response.statusText}');
      }
    } catch (e, stackTrace) {
      debugPrint("Error fetching bookings: $e");
      debugPrint("Stack trace: $stackTrace");
      dateWiseBookingsStatus.value =
          RxStatus.error('Failed to load date-wise bookings');
    } finally {
      debugPrint("Fetch date-wise bookings completed.");
    }
  }
}
