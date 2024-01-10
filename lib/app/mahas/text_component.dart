import 'package:bluetooth_printing_test/app/mahas/mahas_widget.dart';
import 'package:flutter/material.dart';

class TextComponent extends StatelessWidget {
  final String? value;
  final Color fontColor;
  final FontWeight fontWeight;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final bool isMuted;
  final TextAlign textAlign;
  final int? maxLines;
  final Function()? onTap;
  final EdgeInsetsGeometry margin;
  final bool isLoading;
  const TextComponent({
    Key? key,
    @required this.value,
    this.fontColor = Colors.black,
    this.onTap,
    this.isMuted = false,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 12,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.maxLines,
    this.textAlign = TextAlign.start,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? MahasWidget().loadingWidget(
            customWidget: Container(
              height: 15,
              margin: const EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          )
        : Container(
            margin: margin,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: padding,
                child: Text(
                  value!,
                  maxLines: maxLines,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: fontColor.withOpacity(isMuted ? .55 : 1),
                  ),
                  textAlign: textAlign,
                  overflow: maxLines != null ? TextOverflow.ellipsis : null,
                ),
              ),
            ),
          );
  }
}
