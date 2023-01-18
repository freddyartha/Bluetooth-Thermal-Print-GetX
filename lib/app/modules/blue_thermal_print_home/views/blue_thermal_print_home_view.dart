import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/blue_thermal_print_home_controller.dart';

class BlueThermalPrintHomeView extends GetView<BlueThermalPrintHomeController> {
  const BlueThermalPrintHomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Print')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: controller.data.length,
              itemBuilder: (c, i) {
                return ListTile(
                  title: Text(controller.data[i]['title']),
                  subtitle: Text('Rp ${controller.data[i]['price']} x ${controller.data[i]['qty']}'),
                  trailing: Text('Rp ${controller.data[i]['total_price']}'),
                );
              },
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Text(
                      'Total :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp ${controller.total.value}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text('Print', style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      controller.printerState();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
