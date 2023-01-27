import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    controller.goTonormalPrint();
                  },
                  child: const Text("Printing"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    controller.goToThermalPrint();
                  },
                  child: const Text("Bluetooth Printing"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    controller.goToBlue();
                  },
                  child: const Text("Blue Thermal Print (Android)"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    controller.goToPopup();
                  },
                  child: const Text("BirthDay Pop Up"),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       controller.goToWhatsapp();
              //     },
              //     child: const Text("Nota WhatsApp"),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
