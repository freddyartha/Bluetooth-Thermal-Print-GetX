import 'package:bluetooth_printing_test/app/modules/normal_print/bindings/normal_print_binding.dart';
import 'package:bluetooth_printing_test/app/modules/normal_print/views/normal_print_view.dart';
import 'package:bluetooth_printing_test/app/modules/thermal_print/bindings/thermal_print_binding.dart';
import 'package:bluetooth_printing_test/app/modules/thermal_print/views/thermal_print_view.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.normalPrint,
      page: () => NormalPrintView(),
      binding: NormalPrintBinding(),
    ),
    GetPage(
      name: _Paths.thermalPrint,
      page: () => ThermalPrintView(),
      binding: ThermalPrintBinding(),
    ),
  ];
}
