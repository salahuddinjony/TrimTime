import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/info_controller.dart';

class TermsScreen extends StatelessWidget {
  TermsScreen({super.key});
  final InfoController infoController = Get.find<InfoController>();

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map) {
      try {
        userRole = extra['userRole'] as UserRole?;
      } catch (_) {
        userRole = null;
      }
    }
    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.linearFirst,

      ///============================ Header ===============================
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: AppStrings.termsAndConditions,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Obx(() {
          if (infoController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final terms = infoController.terms;
          if (terms.isEmpty) {
            return const Center(
                child: Text('No Terms and Conditions available'));
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: terms.length,
            itemBuilder: (context, index) {
              final term = terms[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      term.heading,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _HtmlTextWidget(htmlContent: term.content),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

// Widget to render HTML content
class _HtmlTextWidget extends StatelessWidget {
  final String htmlContent;

  const _HtmlTextWidget({required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    // Remove HTML tags and decode HTML entities for basic rendering
    String cleanText = htmlContent
        .replaceAll(RegExp(r'<br\s*/?>'), '\n')
        .replaceAll(RegExp(r'<p>'), '\n')
        .replaceAll(RegExp(r'</p>'), '\n')
        .replaceAll(RegExp(r'<li>'), '• ')
        .replaceAll(RegExp(r'</li>'), '\n')
        .replaceAll(RegExp(r'<ul>'), '\n')
        .replaceAll(RegExp(r'</ul>'), '\n')
        .replaceAll(RegExp(r'<ol>'), '\n')
        .replaceAll(RegExp(r'</ol>'), '\n')
        .replaceAll(RegExp(r'<strong>'), '')
        .replaceAll(RegExp(r'</strong>'), '')
        .replaceAll(RegExp(r'<b>'), '')
        .replaceAll(RegExp(r'</b>'), '')
        .replaceAll(RegExp(r'<em>'), '')
        .replaceAll(RegExp(r'</em>'), '')
        .replaceAll(RegExp(r'<i>'), '')
        .replaceAll(RegExp(r'</i>'), '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n')
        .trim();

    return Text(
      cleanText,
      style: TextStyle(
        fontSize: 14.sp,
        color: AppColors.black,
        height: 1.6,
      ),
      softWrap: true,
      textAlign: TextAlign.justify,
    );
  }
}
