import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_barber_job_history.dart';
import 'package:flutter/widgets.dart';

mixin JobApplicationManageMixin on BarberJobHistoryMixin {

  Future<void> getJobApplications() async{
    await  getAllJobHistory(isBarberOwner: true);
    debugPrint("Jxxob Applications fetched: ${jobHistoryList.length}");
  }

}