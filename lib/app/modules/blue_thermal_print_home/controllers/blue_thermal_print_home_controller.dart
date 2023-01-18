import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bluetooth_printing_test/app/modules/blue_therma_print/controllers/blue_therma_print_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';

class BlueThermalPrintHomeController extends GetxController {
  final List<Map<String, dynamic>> data = [
    {
      'title': 'Produk 1',
      'price': 10000,
      'qty': 2,
      'total_price': 20000,
    },
    {
      'title': 'Produk 2',
      'price': 20000,
      'qty': 2,
      'total_price': 40000,
    },
    {
      'title': 'Produk 3',
      'price': 12000,
      'qty': 1,
      'total_price': 12000,
    },
  ];

  final RxInt total = 0.obs;
  final box = GetStorage();

  void hitungTotal(){
    for (var i = 0; i < data.length; i++) {
      total.value = data[i]['total_price'];
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    hitungTotal();
    // box.remove('printer');
    super.onInit();
  }

  printerState(){
    var savedDevice = box.read('printer');
    print(savedDevice);
    final BluetoothDevice printer; 
    if (savedDevice != null) {
      printer = BluetoothDevice.fromMap(savedDevice);
      BlueThermaPrintController().connect(printer);
      Future.delayed(Duration(milliseconds: 1500)).then((value) => BlueThermaPrintController().printData());
    } else{
      // Get.toNamed(Routes.BLUE_THERMA_PRINT,arguments: data);
      Get.toNamed(Routes.BLUE_THERMA_PRINT);
    }
    
  }

}
