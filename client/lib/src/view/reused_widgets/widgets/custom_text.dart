import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String txt;
  final String? fontFam;
  final Color? clr;
  final int? maxLines;
  final double? size;
  final double? height;
  final bool isOverflow;
  final bool isBold;
  final bool withShadow;
  final bool underlined;
  final bool isAnimted;
  final FontWeight? boldness;
  final TextAlign? alignment;
  final Duration? animationDur;
  final double? letterSpacing;

  const CustomText(
      {Key? key,
      required this.txt,
      this.clr,
      this.size,
      this.height,
      this.fontFam,
      this.maxLines,
      this.boldness,
      this.animationDur,
      this.isBold = false,
      this.isOverflow = false,
      this.underlined = false,
      this.isAnimted = false,
      this.withShadow = false,
      this.alignment,
      this.letterSpacing
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isAnimted 
      ? AnimatedDefaultTextStyle(
        duration: animationDur ?? const Duration(milliseconds: 200),
          style: TextStyle(
          color: clr ?? whiteClr,
          decoration: underlined ? TextDecoration.underline : null,
          fontSize: size ?? 18.sp,
          fontWeight: isBold ? FontWeight.bold : boldness,
          fontFamily: fontFam,
          letterSpacing: letterSpacing
        ),
        child: Text(
          txt,
          maxLines: maxLines,
          overflow: isOverflow ? TextOverflow.ellipsis : null,
          textAlign: alignment,
        )
      )
    : Text(
        txt,
        maxLines: maxLines,
        style: TextStyle(
          shadows: withShadow ?  [BoxShadow(offset: Offset(0, 0.1), color: blackClr, blurRadius: 0.1 )] : null,
          height: height,
          color: clr ?? whiteClr,
          decoration: underlined ? TextDecoration.underline : null,
          fontSize: size ?? 18.sp,
          fontWeight: isBold ? FontWeight.bold : boldness,
          fontFamily: fontFam,
          letterSpacing: letterSpacing
        ),
        overflow: isOverflow ? TextOverflow.ellipsis : null,
        textAlign: alignment,
    );
  }
}
