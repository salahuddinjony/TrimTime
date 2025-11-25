import 'dart:convert';
import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/mixin_get_barber_with_date_time/mixin_get_barber_with_date_time.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/mixin_non_registered_bookings/mixin_non_registered_bookings.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/mixin_services/mixin/mixin_get_services.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/mixin_services/model/services_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/queue_management/model/barbers_customer_que_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/queue_management/model/que_model_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin QueManagementMixin
    on
        MixinGetServices,
        GetBarberWithDateTimeMixin,
        MixinNonRegisteredBookings {
  RxInt selectedIndex = 0.obs;
  RxList<QueBarber> queList = <QueBarber>[].obs;
  Rx<RxStatus> queListStatus = Rx<RxStatus>(RxStatus.empty());
  RxBool isQueueEnabled = false.obs; // Track the toggle state

  Rx<BarbersQueData?> barbersCustomerQue = Rx<BarbersQueData?>(null);

  Rx<RxStatus> barbersCustomerQueStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> fetchQueList() async {
    queListStatus.value = RxStatus.loading();

    try {
      final String selonOwnerId =
          await SharePrefsHelper.getString(AppConstants.userId);
      debugPrint('Fetching que list for owner ID: $selonOwnerId');
      final response =
          await ApiClient.getData(ApiUrl.getQueList(id: selonOwnerId));
      debugPrint('API response body: \\n${response.body}');

      if (response.statusCode == 200) {
        final data = QueResponse.fromJson(response.body).data;
        isQueueEnabled.value = data.isQueueEnabled;

        queList.value = data.barbers;
        debugPrint('queList after fetch: \\n${queList.length} items');
        for (var b in queList) {
          debugPrint('Barber: \\n${b.name} - ${b.barberId}');
        }

        queListStatus.value = RxStatus.success();
      } else {
        queListStatus.value = RxStatus.error('Failed to load que list');
      }
    } catch (e) {
      queListStatus.value = RxStatus.error(e.toString());
      debugPrint('Error in fetchQueList: $e');
    }
  }

  // Function to handle the toggle state change
  void toggleQueueStatus(bool value) {
    isQueueEnabled.value = value;
    debugPrint('Queue is ${isQueueEnabled.value ? 'enabled' : 'disabled'}');
    turnOnOffQueueToggle();
  }

  Future<void> turnOnOffQueueToggle() async {
    try {
      final url = ApiUrl.onOffQueueToggle;
      // Ensure the body is sent as a JSON-encoded string
      final response = await ApiClient.patchData(
        url,
        jsonEncode({}), // Send JSON-encoded body
      );

      if (response.statusCode == 200) {
        debugPrint('Queue toggle status updated successfully');
        isQueueEnabled.value = response.body['isQueueEnabled'] as bool;
      } else {
        isQueueEnabled.value =
            !isQueueEnabled.value; // Revert the toggle state on failure
        debugPrint(
            'Failed to update queue toggle status: ${response.statusCode} - ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Error updating queue toggle status: $e');
    }
  }

  Future<void> fetchBarbersCustomerQue({required String barberId, String? saloonOwnerId}) async {
    try {
      barbersCustomerQueStatus.value = RxStatus.loading();

      final String ownerId = saloonOwnerId ?? await SharePrefsHelper.getString(AppConstants.userId) ;
      debugPrint('Fetching barber\'s customer que for owner ID: $ownerId, barber ID: $barberId');
      final url =
          ApiUrl.getBarbersCustomerQue(ownerId: ownerId, barberId: barberId);
      final response = await ApiClient.getData(url);

      if (response.statusCode == 200) {
        final data = BarbersCustomerQueResponse.fromJson(response.body).data;
        barbersCustomerQue.value = data;
        barbersCustomerQueStatus.value = RxStatus.success();
      } else {
        barbersCustomerQueStatus.value =
            RxStatus.error('Failed to load barber\'s customer que');
      }
    } catch (e) {
      barbersCustomerQueStatus.value = RxStatus.error(e.toString());
      debugPrint('Error in fetchBarbersCustomerQue: $e');
    } finally {
      barbersCustomerQueStatus.refresh();
    }
  }

// Register Customer Que Controllers and Logic

  // final TextEditingController dateController = TextEditingController();
  // final TextEditingController timeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  RxList<ServiceItem> get services =>
      servicesList; // From MixinGetServices reactive list

  // RxList<DateTimeWiseBarber> get barberList =>
  //     barberWithDateTimeList; // From GetBarberWithDateTimeMixin reactive list

  RxList<String> servicesSelected = <String>[].obs;
  RxString selectedBarbderId = ''.obs;

  // int calculateTotalServiceTime() {
  //   int totalTime = 0;
  //   for (var service in servicesList) {
  //     if (servicesSelected.contains(service.id)) {
  //       totalTime += service.duration;
  //     }
  //   }
  //   return totalTime;
  // }

  String formattedTime(TimeOfDay time) {
    final myTime = time;
    final hour = myTime.hourOfPeriod == 0 ? 12 : myTime.hourOfPeriod;
    final period = myTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${myTime.minute.toString().padLeft(2, '0')} $period';
  }

  // Future<void> selecTime({required BuildContext context}) async {
  //   final now = TimeOfDay.now();
  //   TimeOfDay? picked;
  //   do {
  //     picked = await showTimePicker(
  //       context: context,
  //       initialTime: now,
  //     );
  //     if (picked == null) return; // User cancelled

  //     final pickedMinutes = picked.hour * 60 + picked.minute;
  //     final nowMinutes = now.hour * 60 + now.minute;

  //     if (pickedMinutes <= nowMinutes) {
  //       EasyLoading.showInfo(
  //           'Pick a later time from now.',
  //           duration: const Duration(seconds: 3));
  //     } else {
  //       final formattedTimeStr = formattedTime(picked);
  //       timeController.text = formattedTimeStr;
  //       debugPrint('Selected time: $picked');
  //       if (timeController.text.isNotEmpty && calculateTotalServiceTime() > 0) {
  //         barberList.clear();
  //         selectedBarbderId.value = '';
  //         await getBarber();
  //       }
  //       break; // Exit the loop if a valid time is picked
  //     }
  //   } while (true); // Repeat until a valid time is picked
  // }

  String get message => msg.value;

  // Future<void> getBarber() async {
  //   // Use the time in hh:mm AM/PM format as required by the API
  //   String timeText = timeController.text.trim();
  //   await getBarberWithDateTime(
  //     time: timeText,
  //     totalServicesTime: calculateTotalServiceTime().toString(),
  //   );
  // }

  Future<bool> registerCustomerQue() async {
    // Use the time in hh:mm AM/PM format for appointmentAt
    // String timeText = timeController.text.trim();
    final success = await registerNonRegisteredBookings(
      fullName: nameController.text,
      email: emailController.text,
      // barberId: selectedBarbderId.value,
      // appointmentAt: timeText,
      services: servicesSelected.isEmpty ? null : servicesSelected.toList(),
      notes: notesController.text,
    );
    if (success) {
      clearControllers();
      fetchQueList();
      debugPrint('Customer que registered successfully.');
    } else {
      debugPrint('Failed to register customer que-----!!!!!!!.');
    }
    return success;
  }

  bool isAllFiledFilled() {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        servicesSelected.isNotEmpty) {
      debugPrint('All fields are filled.');

      return true;
    } else {
      return false;
    }
  }

// Clear all controllers, barberList and selections after successful booking
  void clearControllers() {
    // timeController.clear();
    nameController.clear();
    emailController.clear();
    notesController.clear();
    servicesSelected.clear();
    selectedBarbderId.value = '';
    // barberList.clear();
  }
}
