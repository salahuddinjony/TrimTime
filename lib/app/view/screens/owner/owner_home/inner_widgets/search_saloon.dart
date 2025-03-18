import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter/material.dart';

class SearchSaloon extends StatelessWidget {
  const SearchSaloon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.linearFirst,
      appBar: AppBar(
        title: const Text("What are you looking for?"),
        backgroundColor: AppColors.linearFirst,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: CustomTextField(
          fieldBorderColor: AppColors.black,
          fillColor: AppColors.white50,
          hintText: AppStrings.searchSaloons,
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
