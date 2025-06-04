import 'package:flutter/material.dart';
import '../main.dart';
import '../style/styles.dart';
import '../utils/responsive.dart';

const defaultTextSize = 14.0;

class CustomText extends StatelessWidget {
  String text;
  double fontSize = defaultTextSize;
  bool isBold = false;
  FontStyles? style;
  TextAlign? align;
  Color? color;
  int maxLines;
  double strokeWidth;
  Color? strokeColor;
  bool enableStroke;
  bool isUnderline = false;

  CustomText(this.text,
      {super.key,
      this.style,
      this.align,
      this.isBold = false,
      this.maxLines = 10,
      this.enableStroke = false,
      this.strokeColor,
      this.strokeWidth = 1.0,
      this.isUnderline = false,
      this.fontSize = defaultTextSize,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: align ?? TextAlign.start,
        style: $styles.text
            .getFontStyle(
                fontStyles: style,
                isBold: isBold,
                isUnderline: isUnderline,
                color: color ?? $styles.colors.title,
                fontSize: Responsive.size(context, fontSize))
            .copyWith(
                decoration: isUnderline
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationThickness: 1,
                decorationColor: isUnderline ? $styles.colors.blue : null,
                foreground: enableStroke ? _strokePaint() : null));
  }
  
  Paint _strokePaint() {
    return Paint()
      ..strokeWidth = strokeWidth
      ..color = strokeColor ?? $styles.colors.whiteSplash
      ..style = PaintingStyle.stroke;
  }

}
