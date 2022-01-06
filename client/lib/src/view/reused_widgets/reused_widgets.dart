import 'package:flutter/cupertino.dart';

class ReusedWidgets{
  static spaceOut({double? h, double? w}){
    return h == null && w == null
    ? const SizedBox.shrink()
    : SizedBox(
      height: h,
      width: w,
    );
  }
}