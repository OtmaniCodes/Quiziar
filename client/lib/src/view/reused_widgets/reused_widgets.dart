import 'dart:io';

import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  static Widget showLoading({String? label, double? loaderSize, double?  textSize, Color? color}){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReusedWidgets.spaceOut(h: 60),
        SpinKitWave(
          color: color ?? Colors.white,
          size: loaderSize ?? 50.0,                                    
        ),
        ReusedWidgets.spaceOut(h: 30),
        CustomText(txt: label ?? "Loading...", clr: color, size: textSize)
      ],
    );
  }

  static Widget getProfileImage({bool isAvatar = false, String? imageFilePath, int? avatarIndex, double? width}){
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: ClipOval(
        child: Image(
          width: width,
          height: width,
          fit: BoxFit.fill,
          image: !isAvatar
            ? FileImage(File(imageFilePath??'')) as ImageProvider
            : AssetImage('assets/images/avatars/$avatarIndex.png'),
        ),
      ),
    );
  }

  static Widget getMaterialButton({required void Function()? onPress, Widget? kid, Color? bgColor, bool withRadius = true, String? label, Color? textColor, EdgeInsetsGeometry? givenPadd}){
    return MaterialButton(
      splashColor: whiteClr.withOpacity(0.2),
      highlightColor: whiteClr.withOpacity(0.5),
      padding: givenPadd,
      disabledColor: bgColor?.withOpacity(0.15),
      shape: withRadius ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultRadiusPadd)) : null,
      color: bgColor,
      onPressed: onPress,
      child: kid ?? CustomText(txt: label ?? '', clr: textColor ?? whiteClr),
    );
  }

  static showNotiSnakBar({required String message, Widget? icon, bool fromTop = false, Color? bgColor, bool isPopable = true}){
    Get.showSnackbar(
      GetSnackBar(
        icon: icon,
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        isDismissible: isPopable,
        mainButton: !isPopable ? null : TextButton(child: Text("Ok", style: TextStyle(color: whiteClr)), onPressed: () => Get.back()),
        message: message,
        snackPosition: fromTop ? SnackPosition.TOP : SnackPosition.BOTTOM,
        borderRadius: kDefaultRadiusPadd,
        backgroundColor: bgColor ?? Get.theme.primaryColor,
      ),
    );
  }

  static Widget wrapWithInkEffect(Widget kid, {void Function()? onTap, double? roundingLevel}){
    return Material(
      color: transClr,
      child: InkWell(
        onTap: onTap ?? (){},
        borderRadius: BorderRadius.circular(roundingLevel ?? kDefaultRadiusPadd),
        child: kid,
      ),
    );
  }
}