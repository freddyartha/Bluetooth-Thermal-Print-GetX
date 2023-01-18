import 'package:get/get.dart';

import '../controllers/blue_thermal_print_home_controller.dart';

class BlueThermalPrintHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlueThermalPrintHomeController>(
      () => BlueThermalPrintHomeController(),
    );
  }
}
