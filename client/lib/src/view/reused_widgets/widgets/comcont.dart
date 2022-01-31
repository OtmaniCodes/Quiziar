import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:flutter/material.dart';

class ComCont extends StatelessWidget {
  Widget kid;
  double? height;
  double? width;
  double? borderThickness;
  bool withAnimation;
  Curve? animationCurve;
  Duration? animationDur;
  Color? bgColor;
  Color? borderColor;
  double? roundingLevel;
  EdgeInsetsGeometry? givenPadd;
  EdgeInsetsGeometry? givenMarg;
  
  /// must be false if this.isCircular = true
  bool withRadius;
  bool withBorder;
  bool withShadow;
  bool isCircular;
  void Function()? onTap;
  ComCont({
    Key? key,
    required this.kid,
    this.height,
    this.width,
    this.bgColor,
    this.borderColor,
    this.borderThickness,
    this.givenMarg,
    this.givenPadd,
    this.roundingLevel,
    this.animationDur,
    this.animationCurve,
    this.withAnimation = false,
    this.isCircular = false,
    this.withShadow = false,
    this.withRadius = true,
    this.withBorder = false,
    this.onTap,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoxDecoration _decoration = BoxDecoration(
      shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: withRadius ? BorderRadius.circular(roundingLevel ?? kDefaultRadiusPadd) : null,
      border: withBorder ? Border.all(color: borderColor ?? whiteClr, width: borderThickness ?? 2.0) : null,
      color: bgColor ?? Theme.of(context).canvasColor,    
      boxShadow: withShadow
        ? const [
          BoxShadow(
            color: Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ] : null,
    );
    return GestureDetector(
      onTap: onTap,
      child: !withAnimation
        ? Container(
            height: height,
            width: width,
            padding: givenPadd ?? const EdgeInsets.all(20.0),
            margin: givenMarg ?? const EdgeInsets.all(20.0),
            child: kid,
            decoration: _decoration
          )
        : AnimatedContainer(
            duration: animationDur ?? const Duration(milliseconds: 300),
            curve: animationCurve ?? Curves.linear,
            height: height,
            width: width,
            padding: givenPadd ?? const EdgeInsets.all(20.0),
            margin: givenMarg ?? const EdgeInsets.all(20.0),
            child: kid,
            decoration: _decoration
        ),
    );
  }
}