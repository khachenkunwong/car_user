import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

// model ปุ่มกด
class FFButtonOptions {
  //ค่าที่สามารถรับได้  {}ตัวนี้คอบคือจะใส่ค่าก็ได้ไม่ใส่ก็ได้
  FFButtonOptions({
    this.textStyle,
    this.elevation,
    this.height,
    this.width,
    this.padding,
    // rerquired คือ สิ่งที่จำเป็นต้องใส่
    required this.color,
    this.disabledColor,
    this.disabledTextColor,
    this.splashColor,
    this.iconSize,
    this.iconColor,
    this.iconPadding,
    required this.borderRadius,
    this.borderSide,
  });

  final TextStyle? textStyle;
  final double? elevation;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  Color color = const Color(0xFF00DCA7);
  final Color? disabledColor;
  final Color? disabledTextColor;
  final Color? splashColor;
  final double? iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? iconPadding;
  double borderRadius = 1.0;
  final BorderSide? borderSide;
}

class FFButtonWidget extends StatelessWidget {
  const FFButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.iconData,
    required this.options,
  }) : super(key: key);

  final String text;
  final IconData? iconData;
  final VoidCallback onPressed;
  final FFButtonOptions options;

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: options.textStyle,
      maxLines: 1,
    );
    if (iconData != null) {
      return SizedBox(
        height: options.height,
        width: options.width,
        child: ElevatedButton.icon(
          icon: Padding(
            padding: options.iconPadding ?? EdgeInsets.zero,
            child: FaIcon(
              iconData,
              size: options.iconSize,
              color: options.iconColor ?? options.textStyle?.color,
            ),
          ),
          label: textWidget,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            onSurface: options.disabledColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(options.borderRadius),
              side: options.borderSide ?? BorderSide.none,
            ),
            primary: options.color,
            elevation: options.elevation,
          ),

          // colorBrightness: ThemeData.estimateBrightnessForColor(options.color),
          // textColor: options.textStyle?.color,

          // disabledTextColor: options.disabledTextColor,

          // splashColor: options.splashColor,
        ),
      );
    }

    return Container(
      height: options.height,
      width: options.width,
      padding: options.padding,
      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          onSurface: options.disabledColor,
          elevation: options.elevation,
          primary: options.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(options.borderRadius),
            side: options.borderSide ?? BorderSide.none,
          ),
        ),
        // textColor: options.textStyle?.color,
        // colorBrightness: ThemeData.estimateBrightnessForColor(options.color),
        // disabledColor: options.disabledColor,
        // disabledTextColor: options.disabledTextColor,
        // padding: options.padding,
        child: textWidget,
      ),
    );
  }
}
