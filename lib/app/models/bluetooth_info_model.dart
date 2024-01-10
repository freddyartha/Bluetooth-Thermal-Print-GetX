import 'dart:convert';

import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class BluetoothInfoModel {
  String? name;
  String? macAdress;

  BluetoothInfoModel();

  //use this forn decode
  static BluetoothInfoModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static BluetoothInfoModel fromDynamic(dynamic dynamicData) {
    final model = BluetoothInfoModel();

    model.name = dynamicData['name'];
    model.macAdress = dynamicData['macAdress'];

    return model;
  }

  Map<String, dynamic> bluetoothInfoToJson(BluetoothInfo data) {
    var mapData = {
      'name': data.name,
      'macAdress': data.macAdress,
    };
    return mapData;
  }
}
