import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/model/home_page_deshboard_data/home_page_deshboard_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin DashboardDataMixin {
  Rx<HomePageDashboardData?> dashboardData = Rx<HomePageDashboardData?>(null);
  Rx<RxStatus> dashboardDataStatus = Rx<RxStatus>(RxStatus.empty());

  Future<void> fetchDashboardData() async {
    dashboardDataStatus.value = RxStatus.loading();
    try {
      final response = await ApiClient.getData(ApiUrl.dashboardData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = HomePageDashboardResponse.fromJson(response.body);
        dashboardData.value = body.data;
        dashboardDataStatus.value = RxStatus.success();
      } else {
        debugPrint(
            "Failed to load dashboard data: ${response.statusCode} - ${response.statusText}");
        dashboardDataStatus.value = RxStatus.error(
            'Failed to load dashboard data: ${response.statusText}');
      }

      debugPrint("Dashboard data fetched successfully.");
    } catch (e) {
      debugPrint("Error fetching dashboard data: ${e.toString()}");
      dashboardDataStatus.value =
          RxStatus.error('Failed to load dashboard data');
    } finally {
      debugPrint("Dashboard data fetching completed.");
    }
  }
}
