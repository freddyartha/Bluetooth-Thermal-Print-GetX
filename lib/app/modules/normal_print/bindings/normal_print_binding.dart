import 'package:get/get.dart';

import '../controllers/normal_print_controller.dart';

class NormalPrintBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NormalPrintController>(
      () => NormalPrintController(),
    );
  }
}
