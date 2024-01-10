import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:bluetooth_printing_test/app/mahas/helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ThermalPrintController extends GetxController {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  RxBool connected = false.obs;
  RxString deviceMsg = "no device".obs;
  RxBool isConnected = false.obs;
  RxBool visible = false.obs;
  RxBool success = false.obs;

  Future onRefresh() async {
    // initBluetooth();
    return await initBluetooth();
  }

  Future<void> initBluetooth() async {
    if (EasyLoading.isShow) return;
    await EasyLoading.show();
    // begin scan
    try {
      await bluetoothPrint.startScan(timeout: Duration(seconds: 4));
    } on PlatformException catch (e) {
      EasyLoading.dismiss();
      if (e.message!
          .contains(RegExp("is the adapter on", caseSensitive: false))) {
        return Helper.dialogWarning("Harap Aktifkan Bluetooth Anda!");
      } else {
        return Helper.dialogWarning(e.message);
      }
    } catch (e) {
      EasyLoading.dismiss();
      return Helper.dialogWarning(e.toString());
    }

    // isConnected.value = await bluetoothPrint.isConnected ?? false;

    EasyLoading.dismiss();

    // bluetoothPrint.state.listen((state) {
    //   print('******************* cur device status: $state');

    //   switch (state) {
    //     case BluetoothPrint.CONNECTED:
    //       connected.value = true;
    //       visible.value = true;
    //       print('connect success');
    //       break;
    //     case BluetoothPrint.DISCONNECTED:
    //       connected.value = false;
    //       print('connect failed');
    //       break;
    //     default:
    //       break;
    //   }
    // });

    // if (isConnected.value) {
    //   connected.value = true;
    // }
  }

  Future<void> connect(BluetoothDevice device) async {
    if (EasyLoading.isShow) return;
    await EasyLoading.show();
    if (device.address != null) {
      try {
        await bluetoothPrint.connect(device);
        visible.value = true;
      } catch (e) {
        Helper.dialogWarning(e.toString());
      }
      EasyLoading.dismiss();
    } else {
      print('please select device');
    }
    EasyLoading.dismiss();
  }

  void disconnect(BluetoothDevice device) async {
    if (EasyLoading.isShow) return;
    await EasyLoading.show();
    if (device.address != null) {
      if (connected.value == true) {
        await bluetoothPrint.disconnect();
        visible.value = false;
        print('disconnect');
        EasyLoading.dismiss();
      } else {
        print('no device connected dont have to disconnect');
      }
    } else {
      print('device not connected yet');
    }
    EasyLoading.dismiss();
  }

  startPrint() async {
    if (EasyLoading.isShow) return;
    await EasyLoading.show();

    Map<String, dynamic> config = {};
    RxList<LineText> list = <LineText>[].obs;

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: "Coba Aplikasi\n",
        align: LineText.ALIGN_CENTER,
        fontZoom: 2,
        weight: 1,
        linefeed: 2));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: "Bluetooth Thermal Printing\n",
        align: LineText.ALIGN_CENTER,
        fontZoom: 2,
        weight: 1,
        linefeed: 2));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: "\n",
        align: LineText.ALIGN_CENTER,
        fontZoom: 2,
        linefeed: 5));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '================================================',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Qty',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        x: 0,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Keterangan',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        x: 50,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Satuan',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        x: 400,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Jumlah',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        x: 500,
        relativeX: 0,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '================================================',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 2));

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '\n',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        x: 0,
        relativeX: 0,
        linefeed: 5));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '2',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        x: 0,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Nasi Goreng 1',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        x: 50,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '20.000',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        x: 400,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '40.000',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        x: 500,
        relativeX: 0,
        linefeed: 2));

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '\n',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        x: 0,
        relativeX: 0,
        linefeed: 5));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '1',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        x: 0,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Ayam Geprek + Nasi',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        x: 50,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '15.000',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        x: 400,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '15.000',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        x: 500,
        relativeX: 0,
        linefeed: 2));

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '\n',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        x: 0,
        relativeX: 0,
        linefeed: 5));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '2',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        x: 0,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Tempe',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        x: 50,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: ' 2.000',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        x: 400,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: ' 4.000',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        x: 500,
        relativeX: 0,
        linefeed: 2));

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '\n\n',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        x: 0,
        relativeX: 0,
        linefeed: 5));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: "--- Terima Kasih ---\n",
        align: LineText.ALIGN_CENTER,
        fontZoom: 2,
        linefeed: 2));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: "\n\n\n\n\n",
        align: LineText.ALIGN_CENTER,
        fontZoom: 2,
        weight: 1,
        linefeed: 50));

    await bluetoothPrint.printReceipt(config, list);
    EasyLoading.dismiss();
  }

  @override
  void onInit() {
    initBluetooth();
    super.onInit();
  }

  // @override
  // void onClose() {
  //   disconnect();
  //   super.onClose();
  // }
}
