import 'package:get/get.dart';

import '../controllers/thermal_print_controller.dart';

class ThermalPrintBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThermalPrintController>(
      () => ThermalPrintController(),
    );
  }
}
