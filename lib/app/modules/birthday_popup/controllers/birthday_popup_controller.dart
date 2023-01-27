import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../mahas/helper.dart';

class BirthdayPopupController extends GetxController {
  final box = GetStorage();
  final String title = "Birthday Pop Up View";
  RxBool popUpBool = false.obs;
  
  @override
  void onInit() {
    checkBirthday();
    super.onInit();
  }

  void checkBirthday() {
    DateTime time = DateTime.now();
    var dateRead = box.read('date');
    String? resetTime;
    if(dateRead == null) {
      popUpBool.value = true;
      resetTime = "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} 23:59:59";
      box.write('date', resetTime);
    } else{
      if (time.isAfter(DateTime.parse(dateRead.toString()))) {
        box.remove('date');
        popUpBool.value = true;
      }
    }

    if (popUpBool.value == true) {
      Future.delayed(Duration(milliseconds: 100)).then((value) =>Helper.dialogWarning("Happy Birthday!"));
      popUpBool.value = false;
    }
  }
}
