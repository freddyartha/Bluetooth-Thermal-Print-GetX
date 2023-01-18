import 'package:bluetooth_printing_test/app/mahas/my_config.dart';
import 'package:flutter/material.dart';

enum TextSize {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  normal,
  small,
}

class TextComponent extends StatelessWidget {
  final String data;
  final Color? color;
  final TextSize size;
  final bool muted;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final double? marginTop;
  final double? marginBottom;
  final double? marginLeft;
  final double? marginRight;
  final TextOverflow? overflow;
  final int? maxLines;

  const TextComponent(this.data,
      {Key? key,
      this.overflow,
      this.maxLines, 
      this.color,
      this.size = TextSize.normal,
      this.muted = false,
      this.textAlign,
      this.fontWeight,
      this.marginTop = 0,
      this.marginBottom = 0,
      this.marginLeft = 0,
      this.marginRight = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: marginTop!,
          bottom: marginBottom!,
          left: marginLeft!,
          right: marginRight!),
      child: Text(
        data,
        textAlign: textAlign,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: size == TextSize.h1
              ? MyConfigTextSize.h1
              : size == TextSize.h2
                  ? MyConfigTextSize.h2
                  : size == TextSize.h3
                      ? MyConfigTextSize.h3
                      : size == TextSize.h4
                          ? MyConfigTextSize.h4
                          : size == TextSize.h5
                              ? MyConfigTextSize.h5
                              : size == TextSize.h6
                                  ? MyConfigTextSize.h6
                                  : size == TextSize.small
                                      ? MyConfigTextSize.small
                                      : MyConfigTextSize.normal,
          color: (color ?? MyConfig.fontColor).withOpacity(muted ? .5 : 1),
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
