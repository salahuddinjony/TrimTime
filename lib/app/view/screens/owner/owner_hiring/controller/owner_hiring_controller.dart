import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_barber_job_history.dart';
import 'package:get/get.dart';

class OwnerHiringController extends GetxController with BarberJobHistoryMixin{
  var selectedFilter = "Pending".obs; // Now it's reactive

  get jobHistoryAllList => super.jobHistoryList;



  @override
  void onInit() {
    super.onInit();
    // You can perform additional initialization here if needed
    getAllJobHistory(isBarberOwner: true, status: selectedFilter.value.trim().toUpperCase());
  }

  void filterJobs(String status) {
    selectedFilter.value = status;
    getAllJobHistory(isBarberOwner: true, status: selectedFilter.value.trim().toUpperCase());
  }

  // final List<Map<String, String>> allJobs = [
  //   {
  //     'title': 'James Tracy',
  //     'time': '10:00am-10:00pm',
  //     'price': '£20.00/Per hr',
  //     'date': '02/10/23',
  //     'status': 'Pending'
  //   },

  //   {
  //     'title': 'Esther Howard',
  //     'time': '10:00am-10:00pm',
  //     'price': '£20.00/Per hr',
  //     'date': '02/10/23',
  //     'status': 'Ongoing'
  //   },
  //   {
  //     'title': 'James Tracy',
  //     'time': '11:00am-8:00pm',
  //     'price': '£25.00/Per hr',
  //     'date': '05/10/23',
  //     'status': 'Completed'
  //   },
  //   {
  //     'title': 'Men’s Grooming',
  //     'time': '09:00am-6:00pm',
  //     'price': '£22.00/Per hr',
  //     'date': '07/10/23',
  //     'status': 'Rejected'
  //   },

  // ];
}