import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter/material.dart';

class SearchSaloonScreen extends StatelessWidget {
  const SearchSaloonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: AppColors.first,
        appBar: AppBar(
          title: const Text("What are you looking for?"),
          backgroundColor: AppColors.linearFirst,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.first, // start color
                AppColors.last, // end color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CustomTextField(
              fieldBorderColor: AppColors.black,
              fillColor: AppColors.first,
              hintText: AppStrings.searchSaloons,
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ));
  }
}
