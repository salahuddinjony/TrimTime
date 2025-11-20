import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/business_profile/model/business_profile_data.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

class BarberAddedScreen extends StatelessWidget {
  final UserRole userRole;
  final OwnerProfileController controller;
  BarberAddedScreen(
      {super.key, required this.userRole, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarContent: "Barbers Schedule",
        iconData: Icons.arrow_back,
      ),
      backgroundColor: const Color(0xFFFFD0A3),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: CurvedBannerClipper(),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xCCEDC4AC),
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
                      Obx(() => toggleButtons()),
                      const SizedBox(height: 20),
                      const Text("Select Barber",
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Obx(() {
                        final selectedType = controller.selectedType.value;
                        final barbersList =
                            (controller.businessProfileData.value?.barbers ??
                                    [])
                                .where((barber) => barber.schedules.any((s) =>
                                    s.type.toUpperCase() ==
                                    selectedType.toUpperCase()))
                                .toList();
                        final items = barbersList
                            .map<DropdownMenuItem<String>>(
                                (e) => DropdownMenuItem(
                                      value: e.id,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundImage: e.image.isNotEmpty
                                                ? CachedNetworkImageProvider(
                                                    e.image)
                                                : null,
                                            child: e.image.isEmpty
                                                ? Text(e.fullName.isNotEmpty
                                                    ? e.fullName[0]
                                                    : '?')
                                                : null,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(e.fullName),
                                        ],
                                      ),
                                    ))
                            .toList();
                        final selectedId = controller.selectedBarberId.value;
                        // Only set value if it exists in the items, otherwise null
                        final hasSelected =
                            items.any((item) => item.value == selectedId);
                        if (barbersList.isEmpty) {
                          return Column(
                            children: [
                              const SizedBox(height: 24),
                              Icon(Icons.info_outline,
                                  color: Colors.orange, size: 48),
                              const SizedBox(height: 8),
                              Text(
                                'No barbers available for the selected type.',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.orange),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        }
                        return DropdownButtonFormField<String>(
                          decoration: dropdownDecoration(),
                          value: hasSelected ? selectedId : null,
                          hint: const Text("Select a barber"),
                          items: items,
                          onChanged: (value) =>
                              controller.selectedBarberId.value = value ?? '',
                        );
                      }),
                      const SizedBox(height: 20),
                      scheduleHeader(),
                      Obx(() {
                        final barbers =
                            controller.businessProfileData.value?.barbers ?? [];
                        final selectedId = controller.selectedBarberId.value;
                        final selectedType = controller.selectedType.value;
                        final Barber? selectedBarber = (selectedId.isNotEmpty)
                            ? barbers
                                .firstWhereOrNull((b) => b.id == selectedId)
                            : null;
                        if (selectedId.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Column(
                              children: [
                                Icon(Icons.info_outline,
                                    color: Colors.white70, size: 48),
                                const SizedBox(height: 8),
                                Text(
                                  'Please select a barber from above to view their schedule.',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white70),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }
                        final schedule = (selectedBarber?.schedules ?? [])
                            .where((s) =>
                                s.type.toUpperCase() ==
                                selectedType.toUpperCase())
                            .toList();
                        return Column(children: scheduleFields(schedule));
                      }),
                    ],
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: CustomButton(
            //     onTap: () {
            //       context.pop();
            //     },
            //     title: AppStrings.save,
            //     fillColor: Colors.black,
            //     textColor: Colors.white,
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget toggleButtons() {
    return Row(
      children: [
        toggleButton("Queue"),
        const SizedBox(width: 10),
        toggleButton("Booking"),
      ],
    );
  }

  Widget toggleButton(String type) {
    final isSelected = controller.selectedType.value == type;
    return GestureDetector(
      onTap: () {
        debugPrint('Selected Type: $type');
        controller.selectType(type);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 08),
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
      fillColor: Colors.white.withValues(alpha: .7),
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
                Text("Weekend", style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  List<Widget> scheduleFields(List<dynamic> schedule) {
    return List.generate(schedule.length, (i) {
      final entry = schedule[i];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(entry.dayName.toString().safeCap())),
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: entry.openingTime ?? "",
                onChanged: (val) => entry.openingTime = val,
                decoration: timeFieldDecoration(),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: entry.closingTime ?? "",
                onChanged: (val) => entry.closingTime = val,
                decoration: timeFieldDecoration(),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  color: entry.isActive == true ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  entry.isActive == true ? "No" : "Yes",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
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
