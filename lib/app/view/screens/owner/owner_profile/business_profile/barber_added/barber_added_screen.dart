import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

class BarberAddedScreen extends StatefulWidget {
  const BarberAddedScreen({super.key});

  @override
  State<BarberAddedScreen> createState() => _BarberScheduleScreenState();
}

class _BarberScheduleScreenState extends State<BarberAddedScreen> {
  String scheduleType = "Permanent";
  String? selectedBarber;
  List<String> barbers = ["Barber 1", "Barber 2", "Barber 3"];

  final List<Map<String, dynamic>> schedule = [
    {"day": "Sat", "start": "08:00AM", "end": "08:00AM", "holiday": false},
    {"day": "Sun", "start": "08:00AM", "end": "08:00AM", "holiday": false},
    {"day": "Mon", "start": "08:00AM", "end": "08:00AM", "holiday": false},
    {"day": "Tue", "start": "08:00AM", "end": "08:00AM", "holiday": false},
    {"day": "Wed", "start": "08:00AM", "end": "08:00AM", "holiday": false},
    {"day": "Thur", "start": "08:00AM", "end": "08:00AM", "holiday": false},
    {"day": "Fri", "start": "08:00AM", "end": "08:00AM", "holiday": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          appBarContent: "Barber",
          iconData: Icons.arrow_back,
        ),
        backgroundColor: const Color(0xFFFFD0A3),
        body: Column(
          children: [
            ClipPath(
                clipper: CurvedBannerClipper(),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xCCEDC4AC), // First color (with opacity)
                        Color(0xFFE9864E),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        toggleButtons(),
                        const SizedBox(height: 20),
                        const Text("Select Barber",
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          decoration: dropdownDecoration(),
                          value: selectedBarber,
                          hint: const Text("Barber name"),
                          items: barbers
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => selectedBarber = value),
                        ),
                        const SizedBox(height: 20),
                        scheduleHeader(),
                        ...scheduleFields(),
                      ],
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: CustomButton(
                onTap: () {
                  context.pop();
                },
                title: AppStrings.save,
                fillColor: Colors.black,
                textColor: Colors.white,
              ),
            )
          ],
        ));
  }

  Widget toggleButtons() {
    return Row(
      children: [
        toggleButton("Permanent"),
        const SizedBox(width: 10),
        toggleButton("Temporary"),
      ],
    );
  }

  Widget toggleButton(String type) {
    final isSelected = scheduleType == type;
    return GestureDetector(
      onTap: () => setState(() => scheduleType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  InputDecoration dropdownDecoration() {
    return InputDecoration(
      fillColor: Colors.white.withOpacity(0.7),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    );
  }

  Widget scheduleHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(
            flex: 2,
            child: Text("Day", style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(
            flex: 3,
            child: Text("Start Time",
                style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(
            flex: 3,
            child: Text("End Time",
                style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(
            flex: 2,
            child:
                Text("Holiday", style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  List<Widget> scheduleFields() {
    return schedule.map((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(entry["day"])),
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: entry["start"],
                onChanged: (val) => entry["start"] = val,
                decoration: timeFieldDecoration(),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: entry["end"],
                onChanged: (val) => entry["end"] = val,
                decoration: timeFieldDecoration(),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 2,
              child: Checkbox(
                value: entry["holiday"],
                onChanged: (val) => setState(() => entry["holiday"] = val),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  InputDecoration timeFieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
    );
  }
}
