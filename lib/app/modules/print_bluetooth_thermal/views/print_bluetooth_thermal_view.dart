import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../controllers/print_bluetooth_thermal_controller.dart';

class PrintBluetoothThermalView
    extends GetView<PrintBluetoothThermalController> {
  const PrintBluetoothThermalView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Obx(() {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
            actions: [
              PopupMenuButton(
                elevation: 3.2,
                //initialValue: _options[1],
                onCanceled: () {
                  print('You have not chossed anything');
                },
                tooltip: 'Menu',
                onSelected: (Object select) async {
                  String sel = select as String;
                  if (sel == "permission bluetooth granted") {
                    bool status = await PrintBluetoothThermal
                        .isPermissionBluetoothGranted;
                    controller.info.value =
                        "permission bluetooth granted: $status";
                    //open setting permision if not granted permision
                  } else if (sel == "bluetooth enabled") {
                    bool state = await PrintBluetoothThermal.bluetoothEnabled;
                    controller.info.value = "Bluetooth enabled: $state";
                  } else if (sel == "update info") {
                    controller.initPlatformState();
                  } else if (sel == "connection status") {
                    final bool result =
                        await PrintBluetoothThermal.connectionStatus;
                    controller.info.value = "connection status: $result";
                  }
                },
                itemBuilder: (BuildContext context) {
                  return controller.options.map((String option) {
                    return PopupMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList();
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('info: ${controller.info.value}\n '),
                  Text(controller.msj.value),
                  Row(
                    children: [
                      Text("Type print"),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        value: controller.optionprinttype.value,
                        items: controller.paperOptions.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          controller.optionprinttype.value = newValue!;
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.getBluetoots();
                        },
                        child: Row(
                          children: [
                            Visibility(
                              visible: controller.progress.value,
                              child: SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 1,
                                    backgroundColor: Colors.white),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(controller.progress.value
                                ? controller.msj.value
                                : "Search"),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: controller.connected.value
                            ? controller.disconnect
                            : null,
                        child: Text("Disconnect"),
                      ),
                      ElevatedButton(
                        onPressed: controller.connected.value
                            ? controller.printTest
                            : null,
                        child: Text("Test"),
                      ),
                    ],
                  ),
                  Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: ListView.builder(
                        itemCount: controller.items.isNotEmpty
                            ? controller.items.length
                            : 0,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              String mac = controller.items[index].macAdress;
                              controller.connect(mac);
                            },
                            title:
                                Text('Name: ${controller.items[index].name}'),
                            subtitle: Text(
                                "macAddress: ${controller.items[index].macAdress}"),
                          );
                        },
                      )),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    child: Column(children: [
                      Text(
                          "Text size without the library without external packets, print images still it should not use a library"),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.txtText,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Text",
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          DropdownButton<String>(
                            hint: Text('Size'),
                            value: controller.selectSize.value,
                            items: <String>['1', '2', '3', '4', '5']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? select) {
                              controller.selectSize.value = select.toString();
                            },
                          )
                        ],
                      ),
                      ElevatedButton(
                        onPressed: controller.connected.value
                            ? controller.printWithoutPackage
                            : null,
                        child: Text("Print"),
                      ),
                    ]),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
