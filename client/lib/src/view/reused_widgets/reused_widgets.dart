import 'dart:io';

import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReusedWidgets{
  static spaceOut({double? h, double? w}){
    return h == null && w == null
    ? const SizedBox.shrink()
    : SizedBox(
      height: h,
      width: w,
    );
  }

  static Widget getProfileImage({bool isAvatar = false, String? imageFilePath, int? avatarIndex, double? width}){
    return CircleAvatar(
      radius: width != null ? width / 2 : null,
      backgroundColor: Colors.white,
      backgroundImage: !isAvatar
        ? FileImage(File(imageFilePath??'')) as ImageProvider
        : AssetImage('assets/images/avatars/$avatarIndex.png'),
    );
  }

  static Widget getMaterialButton({required void Function()? onPress, Widget? kid, Color? bgColor, bool withRadius = true, String? label, Color? textColor, EdgeInsetsGeometry? givenPadd}){
    return MaterialButton(
      splashColor: whiteClr.withOpacity(0.2),
      highlightColor: whiteClr.withOpacity(0.5),
      padding: givenPadd,
      shape: withRadius ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultRadiusPadd)) : null,
      color: bgColor,
      onPressed: onPress,
      child: kid ?? CustomText(txt: label ?? '', clr: textColor ?? whiteClr),
    );
  }

  static showNotiSnakBar({required String message, bool fromTop = false, Color? bgColor}){
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        snackPosition: fromTop ? SnackPosition.TOP : SnackPosition.BOTTOM,
        borderRadius: kDefaultRadiusPadd,
        backgroundColor: bgColor ?? Get.theme.primaryColor,
      ),
    );
  }

  static Widget wrapWithInkEffect(Widget kid, {void Function()? onTap}){
    return Material(
      color: transClr,
      child: InkWell(
        onTap: onTap ?? (){},
        child: kid,
      ),
    );
  }
}