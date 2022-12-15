import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/normal_print_controller.dart';

class NormalPrintView extends GetView<NormalPrintController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printing'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
              width: double.infinity,
              height: 500,
              color: Colors.amber.shade300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Makanan Kesukaan",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              )),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              controller.generatePdf();
            },
            child: const Text("Print"),
          ),
        ],
      ),
    );
  }
}
