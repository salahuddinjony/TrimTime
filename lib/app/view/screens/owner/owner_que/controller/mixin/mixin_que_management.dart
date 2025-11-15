import 'dart:convert';
import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/services/mixin/mixin_get_services.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/services/model/services_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/model/barbers_customer_que_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_que/model/que_model_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin QueManagementMixin on MixinGetServices{
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
        isQueueEnabled.value = !isQueueEnabled.value; // Revert the toggle state on failure
        debugPrint(
            'Failed to update queue toggle status: ${response.statusCode} - ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Error updating queue toggle status: $e');
    }
  }

  Future<void> fetchBarbersCustomerQue({required String barberId}) async {
    try {
      barbersCustomerQueStatus.value = RxStatus.loading();

      final String ownerId =
          await SharePrefsHelper.getString(AppConstants.userId);
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
final TextEditingController dateController = TextEditingController();
final TextEditingController timeController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController notesController = TextEditingController();

RxList<ServiceItem> get services => servicesList; // From MixinGetServices reactive list
RxList<dynamic> barberList= <dynamic>[].obs;

RxList<String> servicesSelected = <String>[].obs;
RxString selectedBarbderId = ''.obs;

Future<void> selecTime({required BuildContext context}) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context, 
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
        final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
        final formattedTime = '${hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')} $period';
        timeController.text = formattedTime;
        debugPrint('Selected date: $picked');
      }
    }


}
