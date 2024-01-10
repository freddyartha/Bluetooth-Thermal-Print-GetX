import 'package:bluetooth_printing_test/app/mahas/mahas_font_size.dart';
import 'package:bluetooth_printing_test/app/mahas/text_component.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/print_bluetooth_thermal_ui_controller.dart';

class PrintBluetoothThermalUiView
    extends GetView<PrintBluetoothThermalUiController> {
  const PrintBluetoothThermalUiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Bluetooth Thermal'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            elevation: 3.2,
            tooltip: 'Menu',
            onSelected: (Object select) async {
              String sel = select as String;
              if (sel == "Bluetooth Setting") {
                controller.openBluetoothScanner();
              }
            },
            itemBuilder: (BuildContext context) {
              return controller.options.map((String option) {
                return PopupMenuItem(
                  value: option,
                  child: TextComponent(value: option),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: controller.data.length,
              itemBuilder: (c, i) {
                return ListTile(
                  title: Text(controller.data[i]['title']),
                  subtitle: Text(
                      'Rp ${controller.data[i]['price']} x ${controller.data[i]['qty']}'),
                  trailing: Text('Rp ${controller.data[i]['total_price']}'),
                );
              },
            ),
          ),
          Obx(
            () {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const TextComponent(
                          value: 'TOTAL :',
                          fontWeight: FontWeight.bold,
                          fontSize: MahasFontSize.h3,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        TextComponent(
                          value: 'Rp ${controller.total.value}',
                          fontSize: MahasFontSize.h3,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextComponent(value: "Paper Size :  "),
                        Obx(
                          () {
                            return DropdownButton<String>(
                              isDense: true,
                              value: controller.optionprinttype.value,
                              items:
                                  controller.paperOptions.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: TextComponent(value: option),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                controller.optionprinttype.value = newValue!;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text(
                          'Print',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: controller.printerState,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
