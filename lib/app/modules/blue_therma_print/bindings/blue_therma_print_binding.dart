import 'package:get/get.dart';

import '../controllers/blue_therma_print_controller.dart';

class BlueThermaPrintBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlueThermaPrintController>(
      () => BlueThermaPrintController(),
    );
  }
}
