import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  void goTonormalPrint(){
    Get.toNamed(Routes.normalPrint);
  }

  void goToThermalPrint(){
    Get.toNamed(Routes.thermalPrint);
  }
}
