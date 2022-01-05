import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:flutter/material.dart';

class ComCont extends StatelessWidget {
  Widget kid;
  double? height;
  double? width;
  Color? bgColor;
  Color?borderColor;
  double? roundingLevel;
  EdgeInsetsGeometry? givenPadd;
  EdgeInsetsGeometry? givenMarg;
  bool withRadius;
  bool withBorder;
  bool withShadow;
  ComCont({
    Key? key,
    required this.kid,
    this.height,
    this.width,
    this.bgColor,
    this.borderColor,
    this.givenMarg,
    this.givenPadd,
    this.roundingLevel,
    this.withShadow = false,
    this.withRadius = true,
    this.withBorder = false
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: givenPadd ?? const EdgeInsets.all(20.0),
      margin: givenMarg ?? const EdgeInsets.all(20.0),
      child: kid,
      decoration: BoxDecoration(
        borderRadius: withRadius ? BorderRadius.circular(roundingLevel ?? kDefaultRadiusPadd) : null,
        border: withBorder ? Border.all(color: borderColor ?? whiteClr, width: 2.0) : null,
        color: bgColor ?? Theme.of(context).canvasColor,    
        boxShadow: withShadow
          ? const [
            BoxShadow(
              color: Color(0x29000000),
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ] : null,
      ),
    );
  }
}