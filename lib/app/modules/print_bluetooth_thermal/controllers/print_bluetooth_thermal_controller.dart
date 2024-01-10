import 'dart:io';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:image/image.dart' as img;

class PrintBluetoothThermalController extends GetxController {
  RxString info = "".obs;
  RxString msj = ''.obs;
  RxBool connected = false.obs;
  RxList<BluetoothInfo> items = <BluetoothInfo>[].obs;
  final List<String> options = [
    "permission bluetooth granted",
    "bluetooth enabled",
    "connection status",
    "update info"
  ];

  RxString selectSize = "2".obs;
  final txtText = TextEditingController(text: "Hello developer");
  RxBool progress = false.obs;
  RxString msjprogress = "".obs;

  RxString optionprinttype = "58 mm".obs;
  final List<String> paperOptions = ["58 mm", "80 mm"];

  @override
  void onInit() {
    initPlatformState();
    super.onInit();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    int porcentbatery = 0;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await PrintBluetoothThermal.platformVersion;
      print("patformversion: $platformVersion");
      porcentbatery = await PrintBluetoothThermal.batteryLevel;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    print("bluetooth enabled: $result");
    if (result) {
      msj.value = "Bluetooth enabled, please search and connect";
    } else {
      msj.value = "Bluetooth not enabled";
    }

    info.value = "$platformVersion ($porcentbatery% battery)";
  }

  Future<void> getBluetoots() async {
    progress.value = true;
    msjprogress.value = "Wait";
    items.clear();

    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    /*await Future.forEach(listResult, (BluetoothInfo bluetooth) {
      String name = bluetooth.name;
      String mac = bluetooth.macAdress;
    });*/

    progress.value = false;

    if (listResult.isEmpty) {
      msj.value =
          "There are no bluetoohs linked, go to settings and link the printer";
    } else {
      msj.value = "Touch an item in the list to connect";
    }

    items.value = listResult;
  }

  Future<void> connect(String mac) async {
    progress.value = true;
    msjprogress.value = "Connecting...";
    connected.value = false;

    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    print("state conected $result");
    if (result) connected.value = true;

    progress.value = false;
  }

  Future<void> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;

    connected.value = false;
    print("status disconnect $status");
  }

  Future<void> printTest() async {
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    //print("connection status: $conexionStatus");
    if (conexionStatus) {
      List<int> ticket = await testTicket();
      final result = await PrintBluetoothThermal.writeBytes(ticket);
      print("print test result:  $result");
    } else {
      //no conectado, reconecte
    }
  }

  Future<void> printString() async {
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conexionStatus) {
      String enter = '\n';
      await PrintBluetoothThermal.writeBytes(enter.codeUnits);
      //size of 1-5
      String text = "Hello";
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 1, text: text));
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 2, text: "$text size 2"));
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 3, text: "$text size 3"));
    } else {
      //desconectado
      print("desconectado bluetooth $conexionStatus");
    }
  }

  Future<List<int>> testTicket() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        optionprinttype.value == "58 mm" ? PaperSize.mm58 : PaperSize.mm80,
        profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    final ByteData data = await rootBundle.load('assets/images/logo.png');
    final Uint8List bytesImg = data.buffer.asUint8List();
    img.Image? image = img.decodeImage(bytesImg);

    if (Platform.isIOS) {
      // Resizes the image to half its original size and reduces the quality to 80%
      final resizedImage = img.copyResize(image!,
          width: image.width ~/ 1.3,
          height: image.height ~/ 1.3,
          interpolation: img.Interpolation.nearest);
      final bytesimg = Uint8List.fromList(img.encodeJpg(resizedImage));
      image = img.decodeImage(bytesimg);
    }

    //Using `ESC *`
    bytes += generator.image(image!);

    bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: 'CP1252'));
    bytes += generator.text('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: 'CP1252'));

    bytes += generator.text('Bold text', styles: PosStyles(bold: true));
    bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    bytes +=
        generator.text('Align left', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    //barcode

    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    //QR code
    bytes += generator.qrcode('example.com');

    bytes += generator.text(
      'Text size 50%',
      styles: PosStyles(
        fontType: PosFontType.fontB,
      ),
    );
    bytes += generator.text(
      'Text size 100%',
      styles: PosStyles(
        fontType: PosFontType.fontA,
      ),
    );
    bytes += generator.text(
      'Text size 200%',
      styles: PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  Future<void> printWithoutPackage() async {
    //impresion sin paquete solo de PrintBluetoothTermal
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      String text = "${txtText.text}\n";
      bool result = await PrintBluetoothThermal.writeString(
          printText:
              PrintTextSize(size: int.parse(selectSize.value), text: text));
      print("status print result: $result");
      msj.value = "printed status: $result";
    } else {
      //no conectado, reconecte
      msj.value = "no connected device";
      print("no conectado");
    }
  }
}
