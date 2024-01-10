import 'dart:io';
import 'package:bluetooth_printing_test/app/mahas/my_config.dart';
import 'package:bluetooth_printing_test/app/mahas/text_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class Helper {
  static Future<bool?> dialogQuestion({
    String? message,
    IconData? icon,
    String? textConfirm,
    String? textCancel,
    Color? color,
    Function()? confirmOntap,
    Function()? cancelOntap,
  }) async {
    return await Get.dialog<bool?>(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.question_mark_outlined,
              color: color ?? Colors.amber,
              size: 40,
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Text(
              message ?? "",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        contentPadding:
            const EdgeInsets.only(bottom: 0, top: 20, right: 20, left: 20),
        actionsPadding:
            const EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
        actions: [
          TextButton(
              child: Text(
                textCancel ?? "Close",
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                cancelOntap != null ? cancelOntap() : Get.back(result: false);
              }),
          TextButton(
            child: Text(
              textConfirm ?? "OK",
              style: TextStyle(
                color: color ?? Colors.green,
              ),
            ),
            onPressed: () {
              confirmOntap != null ? confirmOntap() : Get.back(result: false);
            },
          ),
        ],
      ),
    );
  }

  static String? dateToString(DateTime? date,
      {String format = 'yyyy-MM-dd HH:mm', bool returnNull = false}) {
    if (date == null) return returnNull ? null : "";
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(date);
    return formatted;
  }

  static DateTime? stringToDate(String? date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date);
    } catch (ex) {
      return null;
    }
  }

  static TimeOfDay? stringToTime(String? time) {
    if (time == null) return null;
    final add = time.indexOf("PM") > 0 ? 12 : 0;
    final r = TimeOfDay(
        hour: int.parse(time.split(":")[0]) + add,
        minute: int.parse(time.split(":")[1].split(' ')[0]));
    return r;
  }

  static String? timeToString(
    TimeOfDay? time, {
    bool twentyFour = true,
    bool returnNull = false,
    bool millisecond = false,
  }) {
    if (time == null) return returnNull ? null : "";
    var hour =
        twentyFour ? time.hour : (time.hour > 12 ? time.hour - 12 : time.hour);
    if (hour == 0) {
      hour = 12;
    }
    var minute = time.minute;
    var strHour = hour > 9 ? '$hour' : '0$hour';
    var strMinute = minute > 9 ? '$minute' : '0$minute';
    var r = "$strHour:$strMinute";
    if (millisecond) {
      r += ":00";
    }
    return twentyFour ? r : '$r ${time.hour > 12 ? 'PM' : 'AM'}';
  }

  static Future dialogShow(String message) async {
    await Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextComponent(
              value: message,
              fontColor: MyConfig.primaryColor.shade900,
            ),
          ],
        ),
        contentPadding:
            EdgeInsets.only(bottom: 0, top: 30, right: 10, left: 10),
        actionsPadding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
        actions: [
          TextButton(
            child: TextComponent(
              value: "Close",
              fontColor: MyConfig.primaryColor.shade500,
            ),
            onPressed: () {
              Get.back(result: false);
            },
          ),
        ],
      ),
    );
  }

  static Widget showLoading() {
    return Container(
      alignment: Alignment.center,
      child: (kIsWeb)
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: CupertinoActivityIndicator(),
            )
          : (Platform.isIOS)
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CupertinoActivityIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(),
                ),
    );
  }

  static double childAspekRasioKalender(BuildContext context) {
    if (kIsWeb) {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return 1;
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        return 0.9;
      } else if (defaultTargetPlatform == TargetPlatform.fuchsia) {
        return 0.8;
      } else if (defaultTargetPlatform == TargetPlatform.linux) {
        return 1.8;
      } else if (defaultTargetPlatform == TargetPlatform.macOS) {
        return 1.8;
      } else if (defaultTargetPlatform == TargetPlatform.windows) {
        return 1.8;
      } else {
        return 1.8;
      }
    } else {
      if (Platform.isIOS) {
        return 1;
      } else {
        return 1.5;
      }
    }
  }

  static bool isTablet(BuildContext context) {
    final data = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.single);
    return data.size.shortestSide < 550 ? false : true;
  }

  static Future dialogWarning(String? message) async {
    await Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.circle,
              color: MyConfig.primaryColor.shade800,
              size: 40,
            ),
            Padding(padding: EdgeInsets.all(7)),
            TextComponent(
              value: message ?? "-",
              fontColor: MyConfig.primaryColor.shade900,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  static Future dialogCustomWidget(List<Widget> children) async {
    await Get.dialog(
      AlertDialog(
        content: Column(mainAxisSize: MainAxisSize.min, children: children),
        contentPadding:
            EdgeInsets.only(bottom: 0, top: 30, right: 10, left: 10),
        actionsPadding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
        actions: [
          TextButton(
            child: TextComponent(
              value: "Close",
              fontColor: MyConfig.primaryColor.shade500,
            ),
            onPressed: () {
              Get.back(result: false);
            },
          ),
        ],
      ),
    );
  }

  static String currencyFormat(double? value, {bool zeroIsEmpty = true}) {
    final oCcy = NumberFormat("#,###.##########", "en_US");
    var val = oCcy.format(value ?? 0);
    return val == "0" && zeroIsEmpty ? "" : val;
  }
}
