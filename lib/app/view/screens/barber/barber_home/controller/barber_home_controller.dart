import 'package:get/get.dart';

class BarberHomeController extends GetxController{
  var selectedFilter = "Nearby job".obs; // Now it's reactive

  final List<Map<String, String>> allJobs = [
    {
      'title': 'Barber Shop',
      'time': '10:00am-10:00pm',
      'price': '£20.00/Per hr',
      'date': '02/10/23',
      'status': 'Nearby job'
    },

    {
      'title': 'Barber Shop',
      'time': '10:00am-10:00pm',
      'price': '£20.00/Per hr',
      'date': '02/10/23',
      'status': 'Nearby job'
    },
    {
      'title': 'Salon',
      'time': '11:00am-8:00pm',
      'price': '£25.00/Per hr',
      'date': '05/10/23',
      'status': 'Pending'
    },
    {
      'title': 'Men’s Grooming',
      'time': '09:00am-6:00pm',
      'price': '£22.00/Per hr',
      'date': '07/10/23',
      'status': 'Approve'
    },
    {
      'title': 'Luxury Salon',
      'time': '12:00pm-9:00pm',
      'price': '£30.00/Per hr',
      'date': '10/10/23',
      'status': 'Rejected'
    },
  ];
}