import 'package:get/get.dart';

import '../controllers/birthday_popup_controller.dart';

class BirthdayPopupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BirthdayPopupController>(
      () => BirthdayPopupController(),
    );
  }
}
