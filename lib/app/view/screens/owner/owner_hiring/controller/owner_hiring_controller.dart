import 'package:get/get.dart';

class OwnerHiringController extends GetxController{
  var selectedFilter = "Pending".obs; // Now it's reactive

  final List<Map<String, String>> allJobs = [
    {
      'title': 'Barber Shop',
      'time': '10:00am-10:00pm',
      'price': '£20.00/Per hr',
      'date': '02/10/23',
      'status': 'Pending'
    },

    {
      'title': 'Barber Shop',
      'time': '10:00am-10:00pm',
      'price': '£20.00/Per hr',
      'date': '02/10/23',
      'status': 'Ongoing'
    },
    {
      'title': 'Salon',
      'time': '11:00am-8:00pm',
      'price': '£25.00/Per hr',
      'date': '05/10/23',
      'status': 'Completed'
    },
    {
      'title': 'Men’s Grooming',
      'time': '09:00am-6:00pm',
      'price': '£22.00/Per hr',
      'date': '07/10/23',
      'status': 'Rejected'
    },

  ];
}