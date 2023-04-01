import 'package:clinic_admin/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;

  final double fontSize;
  final FontWeight fontWeight;

  final Color color;

  final Alignment alignment;

  final int? maxLine;

  CustomText({
    this.text = '',
    this.fontSize = 14,
    this.color = primaryColor,
    this.alignment = Alignment.center,
    this.maxLine=2,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLine,

        style: TextStyle(

          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
