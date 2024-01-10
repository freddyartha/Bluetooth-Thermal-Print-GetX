import 'package:get/get.dart';

import '../controllers/print_bluetooth_thermal_ui_controller.dart';

class PrintBluetoothThermalUiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrintBluetoothThermalUiController>(
      () => PrintBluetoothThermalUiController(),
    );
  }
}
