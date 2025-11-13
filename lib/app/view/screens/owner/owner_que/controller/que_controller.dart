import 'package:barber_time/app/view/screens/owner/owner_que/controller/mixin/mixin_que_management.dart';
import 'package:get/get.dart';

class QueController extends GetxController with QueManagementMixin{
  var selectedValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQueList();
    selectedValue.value = '';
  }
}
