import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/blue_therma_print_controller.dart';

class BlueThermaPrintView extends GetView<BlueThermaPrintController> {
  const BlueThermaPrintView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print'),
      ),
      body: Obx((() =>  controller.devices.isEmpty
          ? Center(child: Text(controller.devicesMsg))
          : ListView.builder(
              itemCount: controller.devices.length,
              itemBuilder: (c, i) {
                return ListTile(
                  leading: const Icon(Icons.print),
                  title: Text(controller.devices[i].name ?? ""),
                  subtitle: Text(controller.devices[i].address ?? ""),
                  onTap: () {
                    controller.device = controller.devices[i];
                    controller.connect(controller.device!);
                  },
                );
              },
            )
      ),
      ),
    );
  }
  
}
