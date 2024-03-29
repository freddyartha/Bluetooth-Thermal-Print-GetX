import 'package:get/get.dart';

import '../modules/birthday_popup/bindings/birthday_popup_binding.dart';
import '../modules/birthday_popup/views/birthday_popup_view.dart';
import '../modules/blue_therma_print/bindings/blue_therma_print_binding.dart';
import '../modules/blue_therma_print/views/blue_therma_print_view.dart';
import '../modules/blue_thermal_print_home/bindings/blue_thermal_print_home_binding.dart';
import '../modules/blue_thermal_print_home/views/blue_thermal_print_home_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/normal_print/bindings/normal_print_binding.dart';
import '../modules/normal_print/views/normal_print_view.dart';
import '../modules/print_bluetooth_thermal/bindings/print_bluetooth_thermal_binding.dart';
import '../modules/print_bluetooth_thermal/views/print_bluetooth_thermal_view.dart';
import '../modules/print_bluetooth_thermal_ui/bindings/print_bluetooth_thermal_ui_binding.dart';
import '../modules/print_bluetooth_thermal_ui/views/print_bluetooth_thermal_ui_view.dart';
import '../modules/thermal_print/bindings/thermal_print_binding.dart';
import '../modules/thermal_print/views/thermal_print_view.dart';

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
    GetPage(
      name: _Paths.BLUE_THERMA_PRINT,
      page: () => const BlueThermaPrintView(),
      binding: BlueThermaPrintBinding(),
    ),
    GetPage(
      name: _Paths.BLUE_THERMAL_PRINT_HOME,
      page: () => const BlueThermalPrintHomeView(),
      binding: BlueThermalPrintHomeBinding(),
    ),
    GetPage(
      name: _Paths.BIRTHDAY_POPUP,
      page: () => const BirthdayPopupView(),
      binding: BirthdayPopupBinding(),
    ),
    GetPage(
      name: _Paths.PRINT_BLUETOOTH_THERMAL,
      page: () => const PrintBluetoothThermalView(),
      binding: PrintBluetoothThermalBinding(),
    ),
    GetPage(
      name: _Paths.PRINT_BLUETOOTH_THERMAL_UI,
      page: () => const PrintBluetoothThermalUiView(),
      binding: PrintBluetoothThermalUiBinding(),
    ),
  ];
}
