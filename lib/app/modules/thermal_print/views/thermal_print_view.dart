import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/thermal_print_controller.dart';

class ThermalPrintView extends GetView<ThermalPrintController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BluetoothPrinting View'),
        centerTitle: true,
      ),
      // get devices
      body: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: [
            StreamBuilder<List<BluetoothDevice>>(
              stream: controller.bluetoothPrint.scanResults,
              initialData: const [],
              builder: (c, snapshot) => Column(
                children: snapshot.data!
                    .map((d) => ListTile(
                          title: Text(d.name ?? ''),
                          subtitle: Text(d.address ?? ''),
                          onTap: () async {
                            controller.device.value = d;
                            // controller.connect();
                          },
                          trailing: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.183,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: MediaQuery.of(context).size.height,
                                  child: InkWell(
                                    onTap: () async {
                                      controller.device.value = d;
                                      controller.connect();
                                    },
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 30,
                                  height: MediaQuery.of(context).size.height,
                                  child: InkWell(
                                    onTap: () async {
                                      controller.disconnect();
                                    },
                                    child: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Obx((() => 
              Visibility(
                visible: controller.visible.value,
                child: Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.connected.value == true
                        ? () async {
                            controller.startPrint();
                          }
                        : null,
                    child: Text("Print"),
                  ),
                ),
              )
            ),
            ),
          ],
        ),
      ),
    );
  }
}
