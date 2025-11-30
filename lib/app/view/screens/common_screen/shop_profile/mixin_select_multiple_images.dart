import 'dart:io';

import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

mixin SelectMultipleImagesMixin {
  RxList<File> imagePaths = RxList<File>([]);
// select multiple images and add their paths to imagePaths list

  final ImagePicker _picker = ImagePicker();

  //CLICK TO SELECT MULTIPLE IMAGES AND add profolio images function
  Future<void> pickImages() async {
    final List<XFile>? picked = await _picker.pickMultiImage();
    if (picked != null) {
      for (var image in picked) {
        if (imagePaths.length < 5) {
          imagePaths.add(File(image.path));
        } else {
          EasyLoading.showInfo('You can select up to 5 images only');
          break;
        }
      }
    }
  }

  void addImage(File path) {
    if (imagePaths.length <= 5) {
      imagePaths.add(path);
    } else {
      toastMessage(message: 'You can select up to 5 images only');
    }
  }

  void removeImage(int index) {
    imagePaths.removeAt(index);
  }
}
