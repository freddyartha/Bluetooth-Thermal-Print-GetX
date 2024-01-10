import 'package:get/get.dart';

import '../controllers/print_bluetooth_thermal_controller.dart';

class PrintBluetoothThermalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrintBluetoothThermalController>(
      () => PrintBluetoothThermalController(),
    );
  }
}
