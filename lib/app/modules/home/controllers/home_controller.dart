import 'package:bluetooth_printing_test/app/mahas/helper.dart';
import 'package:bluetooth_printing_test/app/mahas/input_text_component.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
// import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../mahas/my_config.dart';
import '../../../mahas/text_component.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
    } else {
      // _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  // void _handleInvalidPermissions(PermissionStatus permissionStatus) {
  //   if (permissionStatus == PermissionStatus.denied) {
  //     final snackBar = SnackBar(content: Text('Access to contact data denied'));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
  //     final snackBar =
  //         SnackBar(content: Text('Contact data not available on device'));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }

  // late RxList<Contact> _contacts;
  final RxList _contacts = [].obs;

  Future<void> refreshContacts() async {
    // Load without thumbnails initially.
    var contacts = (await ContactsService.getContacts(withThumbnails: false));
//      var contacts = (await ContactsService.getContactsForPhone("8554964652"))
//          ;
    // setState(() {
    _contacts.value = contacts;
    for (var i = 0; i < contacts.length; i++) {
      print(contacts[i].displayName);
    }
    // });
  }

  void goTonormalPrint() {
    Get.toNamed(Routes.normalPrint);
  }

  void goToThermalPrint() {
    Get.toNamed(Routes.thermalPrint);
  }

  void goToBlue() {
    Get.toNamed(Routes.BLUE_THERMAL_PRINT_HOME);
  }

  void goToPrintBluetoothThermal() {
    Get.toNamed(Routes.PRINT_BLUETOOTH_THERMAL_UI);
  }

  void goToPopup() {
    Get.toNamed(Routes.BIRTHDAY_POPUP);
  }

  final noHPCon = InputTextController();
  void goToWhatsapp() {
    Helper.dialogCustomWidget([
      InputTextComponent(
        controller: noHPCon,
        label: "Masukkan Nomor Handphone",
        type: InputTextType.number,
      ),
      Row(
        children: [
          TextButton(
            child: TextComponent(
              value: "Simpan",
              fontColor: MyConfig.primaryColor.shade500,
            ),
            onPressed: () {
              launchWhatsAppString();
            },
          ),
          TextButton(
            child: TextComponent(
              value: "Pilih Kontak",
              fontColor: MyConfig.primaryColor.shade500,
            ),
            onPressed: () async {
              _askPermissions();
              // final PhoneContact contact =
              //   await FlutterContactPicker.pickPhoneContact();
              // noHPCon.value = contact.phoneNumber;
            },
          ),
        ],
      ),
    ]);
  }

  launchWhatsAppString() async {
    final link = WhatsAppUnilink(
      phoneNumber: '${noHPCon.value}',
      text: "Hey! I'm inquiring about the apartment listing",
    );
    await launchUrlString('$link');
  }

  // pilihKontak()async {
  //   final PhoneContact contact =
  //   await FlutterContactPicker.pickPhoneContact();
  // }
}
