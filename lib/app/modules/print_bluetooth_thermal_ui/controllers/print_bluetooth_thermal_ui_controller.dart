import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:bluetooth_printing_test/app/mahas/mahas_widget.dart';
import 'package:bluetooth_printing_test/app/mahas/text_component.dart';
import 'package:bluetooth_printing_test/app/models/bluetooth_info_model.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:image/image.dart' as img;

import '../../../mahas/helper.dart';

class PrintBluetoothThermalUiController extends GetxController {
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
  final List<String> options = ["Bluetooth Setting"];
  final List<String> paperOptions = ["58 mm", "80 mm"];
  RxString optionprinttype = "58 mm".obs;
  RxInt total = 0.obs;
  final box = GetStorage();

  RxList<BluetoothInfo> bluetoothItems = <BluetoothInfo>[].obs;
  RxBool isConnected = false.obs;
  RxString connectedMacAddress = "".obs;
  RxBool isLoading = false.obs;

  void hitungTotal() {
    for (var i = 0; i < data.length; i++) {
      total.value = data[i]['total_price'];
    }
  }

  @override
  void onInit() async {
    hitungTotal();
    BluetoothInfoModel bluetoothInfoModel = await readPrinterStorage();
    connectedMacAddress.value = bluetoothInfoModel.macAdress ?? "";
    super.onInit();
  }

  @override
  void onClose() async {
    isConnected.value = await PrintBluetoothThermal.disconnect;
    connectedMacAddress.value = "";
  }

  Future<BluetoothInfoModel> readPrinterStorage() async {
    var savedDevice = await box.read('printer');
    if (savedDevice != null) {
      BluetoothInfoModel bluetoothInfoModel =
          BluetoothInfoModel.fromJson(savedDevice);
      return bluetoothInfoModel;
    } else {
      return BluetoothInfoModel();
    }
  }

  Future<void> printerState() async {
    bool bluetoothOn = await PrintBluetoothThermal.bluetoothEnabled;
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;

    if (!bluetoothOn) {
      Helper.dialogQuestion(
        message: "Please Turn On Your Bluetooth!",
        textConfirm: "Go To Setting",
        confirmOntap: () {
          Get.back();
          AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
        },
      );
    } else if (connectionStatus) {
      printTest();
    } else {
      BluetoothInfoModel bluetoothInfoModel = await readPrinterStorage();
      if (bluetoothInfoModel.name != null &&
          bluetoothInfoModel.macAdress != null) {
        Helper.dialogQuestion(
            message:
                "you are already connected to ${bluetoothInfoModel.name}, \nprint with this device?",
            confirmOntap: () async {
              Get.back();
              await connect(BluetoothInfo(
                      name: bluetoothInfoModel.name!,
                      macAdress: bluetoothInfoModel.macAdress!))
                  .then((value) async => await printTest());
            },
            textCancel: "New Bluetooth Connection",
            cancelOntap: () async {
              Get.back();
              await disconnect();
              await openBluetoothScanner();
            });
      } else {
        await openBluetoothScanner();
      }
    }
  }

  Future<void> openBluetoothScanner() async {
    await getBluetoots();

    await showMaterialModalBottomSheet(
      context: Get.context!,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Bluetooth Devices"),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: getBluetoots,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Obx(
              () => isLoading.value
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) => Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MahasWidget().loadingWidget(
                              customWidget: MahasWidget()
                                  .customLoadingWidget(width: Get.width),
                            ),
                            MahasWidget().loadingWidget(
                              customWidget: MahasWidget()
                                  .customLoadingWidget(width: Get.width * 0.7),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  : bluetoothItems.isEmpty
                      ? Container(
                          height: 300,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextComponent(
                                  value: "No Bluetooth Device found",
                                  margin: EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                ),
                                Icon(
                                  Icons.replay_outlined,
                                  size: 30,
                                ),
                                TextComponent(
                                  value: "Retry",
                                  isMuted: true,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  onTap: getBluetoots,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: bluetoothItems.length,
                          itemBuilder: (context, index) {
                            var item = bluetoothItems[index];
                            return ListTile(
                              onTap: () {
                                if (connectedMacAddress.value !=
                                    item.macAdress) {
                                  connect(item);
                                }
                              },
                              contentPadding: EdgeInsets.all(0),
                              title: TextComponent(value: item.name),
                              subtitle: TextComponent(
                                value: item.macAdress,
                                isMuted: true,
                              ),
                              trailing: Obx(
                                () => connectedMacAddress.value !=
                                        item.macAdress
                                    ? MahasWidget().hideWidget()
                                    : SizedBox(
                                        height: Get.height,
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          runAlignment: WrapAlignment.center,
                                          alignment: WrapAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              child: Center(
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            InkWell(
                                              onTap: disconnect,
                                              child: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: Center(
                                                  child: const Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getBluetoots() async {
    isLoading.value = true;
    bluetoothItems.clear();
    bluetoothItems.value = await PrintBluetoothThermal.pairedBluetooths;
    isLoading.value = false;
  }

  Future<void> connect(BluetoothInfo device) async {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    EasyLoading.show();

    isConnected.value = await PrintBluetoothThermal.connect(
        macPrinterAddress: device.macAdress);
    if (!isConnected.value) {
      EasyLoading.dismiss();
      Helper.dialogWarning(
          "Error Occured!\nCannot connect to this bluetooth device");
    } else {
      var savedDevice = await box.read('printer');
      if (savedDevice == null) {
        Helper.dialogQuestion(
          message:
              "Do you want this app to autoconnect to this bluetooth device?",
          confirmOntap: () async {
            await box.write(
              "printer",
              jsonEncode(
                BluetoothInfoModel().bluetoothInfoToJson(
                  device,
                ),
              ),
            );
            Get.back();
          },
        );
      }
      connectedMacAddress.value = device.macAdress;
      EasyLoading.dismiss();
    }
  }

  Future<void> disconnect() async {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    EasyLoading.show();
    var savedDevice = await box.read('printer');
    if (savedDevice != null) {
      box.remove("printer");
    }
    isConnected.value = await PrintBluetoothThermal.disconnect;
    connectedMacAddress.value = "";
    EasyLoading.dismiss();
  }

  Future<void> printTest() async {
    List<int> ticket = await printTicket();
    await PrintBluetoothThermal.writeBytes(ticket);
  }

  Future<List<int>> shortTestTicket() async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        optionprinttype.value == "58 mm" ? PaperSize.mm58 : PaperSize.mm80,
        profile);
    bytes += generator.setGlobalFont(PosFontType.fontB);
    bytes += generator.reset();

    //Using `ESC *`
    bytes += generator.row(
      [
        PosColumn(
          text: 'Description',
          width: 7,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: 'Qty',
          width: 1,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: 'Price',
          width: 2,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: 'Total',
          width: 2,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
      ],
    );
    return bytes;
  }

  Future<List<int>> printTicket() async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        optionprinttype.value == "58 mm" ? PaperSize.mm58 : PaperSize.mm80,
        profile);
    bytes += generator.setGlobalFont(PosFontType.fontB);
    bytes += generator.reset();

    final ByteData imageData = await rootBundle.load('assets/images/logo.jpg');
    final Uint8List bytesImg = imageData.buffer.asUint8List();
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
    // bytes += generator.image(image!);
    // bytes += generator.emptyLines(1);
    bytes += generator.text(
      "Aplikasi HR Portal",
      styles: PosStyles(bold: true, align: PosAlign.center),
    );
    bytes += generator.text(
      "Jl. Demo Demo Demo",
      styles: PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      "Telp. 123123",
      styles: PosStyles(align: PosAlign.center),
    );
    bytes += generator.hr();
    bytes += generator.row(
      [
        PosColumn(
          text: 'Description',
          width: 7,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: 'Qty',
          width: 1,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: 'Price',
          width: 2,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: 'Total',
          width: 2,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
      ],
    );
    bytes += generator.hr();
    for (var i = 0; i < data.length; i++) {
      bytes += generator.row(
        [
          PosColumn(
            text: data[i]['title'],
            width: 7,
            styles: PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: data[i]['qty'].toString(),
            width: 1,
            styles: PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: data[i]['price'].toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            text: data[i]['total_price'].toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right),
          ),
        ],
      );
    }
    bytes += generator.hr(linesAfter: 1);
    bytes += generator.row(
      [
        PosColumn(
          text: 'Total',
          width: 7,
          styles: PosStyles(
            align: PosAlign.right,
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ),
        ),
        PosColumn(
          text: total.value.toString(),
          width: 5,
          styles: PosStyles(
            align: PosAlign.right,
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ),
        ),
      ],
    );
    bytes += generator.hr();
    bytes += generator.text(
      "This Receipt is Generated by System",
      styles: PosStyles(bold: true, align: PosAlign.center),
    );
    bytes += generator.feed(1);
    bytes += generator.cut();
    return bytes;
  }

  // //This fuction is for example of all the capabilities of the print_bluetooth_thermal package
  // Future<List<int>> testTicket() async {
  //   List<int> bytes = [];
  //   // Using default profile
  //   final profile = await CapabilityProfile.load();
  //   final generator = Generator(
  //       // optionprinttype.value == "58 mm" ?
  //       PaperSize.mm58,
  //       // : PaperSize.mm80,
  //       profile);
  //   //bytes += generator.setGlobalFont(PosFontType.fontA);
  //   bytes += generator.reset();

  //   final ByteData data = await rootBundle.load('assets/images/logo.png');
  //   final Uint8List bytesImg = data.buffer.asUint8List();
  //   img.Image? image = img.decodeImage(bytesImg);

  //   if (Platform.isIOS) {
  //     // Resizes the image to half its original size and reduces the quality to 80%
  //     final resizedImage = img.copyResize(image!,
  //         width: image.width ~/ 1.3,
  //         height: image.height ~/ 1.3,
  //         interpolation: img.Interpolation.nearest);
  //     final bytesimg = Uint8List.fromList(img.encodeJpg(resizedImage));
  //     image = img.decodeImage(bytesimg);
  //   }

  //   //Using `ESC *`
  //   bytes += generator.image(image!);

  //   bytes += generator.text(
  //       'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  //   bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ',
  //       styles: PosStyles(codeTable: 'CP1252'));
  //   bytes += generator.text('Special 2: blåbærgrød',
  //       styles: PosStyles(codeTable: 'CP1252'));

  //   bytes += generator.text('Bold text', styles: PosStyles(bold: true));
  //   bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
  //   bytes += generator.text('Underlined text',
  //       styles: PosStyles(underline: true), linesAfter: 1);
  //   bytes +=
  //       generator.text('Align left', styles: PosStyles(align: PosAlign.left));
  //   bytes += generator.text('Align center',
  //       styles: PosStyles(align: PosAlign.center));
  //   bytes += generator.text('Align right',
  //       styles: PosStyles(align: PosAlign.right), linesAfter: 1);

  //   bytes += generator.row([
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col6',
  //       width: 6,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //   ]);

  //   //barcode

  //   final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
  //   bytes += generator.barcode(Barcode.upcA(barData));

  //   //QR code
  //   bytes += generator.qrcode('example.com');

  //   bytes += generator.text(
  //     'Text size 50%',
  //     styles: PosStyles(
  //       fontType: PosFontType.fontB,
  //     ),
  //   );
  //   bytes += generator.text(
  //     'Text size 100%',
  //     styles: PosStyles(
  //       fontType: PosFontType.fontA,
  //     ),
  //   );
  //   bytes += generator.text(
  //     'Text size 200%',
  //     styles: PosStyles(
  //       height: PosTextSize.size2,
  //       width: PosTextSize.size2,
  //     ),
  //   );

  //   bytes += generator.feed(2);
  //   bytes += generator.cut();
  //   return bytes;
  // }
}
