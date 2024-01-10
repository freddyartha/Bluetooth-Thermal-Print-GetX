import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'mahas_colors.dart';
import 'mahas_font_size.dart';
import 'text_component.dart';

class MahasWidget {
  PreferredSizeWidget mahasAppBar({
    required String title,
    Color background = MahasColors.main,
    IconData backIcon = Icons.arrow_back_ios,
    Color appBarItemColor = MahasColors.light,
    double elevation = 4,
    Function()? onBackTap,
    bool isLeading = true,
    TextAlign titleAlign = TextAlign.center,
    List<Widget>? actionBtn,
  }) {
    return AppBar(
      elevation: elevation,
      title: TextComponent(
        value: title,
        fontSize: MahasFontSize.actionBartitle,
        fontColor: appBarItemColor,
        fontWeight: FontWeight.w500,
        textAlign: titleAlign,
      ),
      backgroundColor: background,
      leading: isLeading == true
          ? IconButton(
              onPressed: onBackTap ??
                  () {
                    Get.back(result: true);
                  },
              icon: Icon(backIcon),
            )
          : null,
      iconTheme: IconThemeData(
        color: appBarItemColor,
      ),
      actions: actionBtn,
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Widget hideWidget() {
    return Visibility(visible: false, child: Container());
  }

  Widget loadingWidget({Widget? customWidget}) {
    return customWidget != null
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled: true,
            child: customWidget)
        : const Row(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: MahasColors.main,
                ),
              ),
            ],
          );
  }

  Widget customLoadingWidget({double? width}) {
    return Container(
      height: 15,
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: MahasColors.light,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
