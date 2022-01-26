import 'package:client/src/state/controllers/profile_image_controller.dart';
import 'package:client/src/state/controllers/user_contollers/username.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileImageController _profileImageController = Get.find<ProfileImageController>();
    final UsernameController _usernameCtler = Get.put(UsernameController()); 
    // final UsernameController _usernameCtler = Get.find<UsernameController>(); //!use this one 
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_outlined)
        ),
        backgroundColor: transClr,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: CustomText(txt: "AhmedCodor", size: 20.sp, fontFam: 'boldPoppins'),//_usernameCtler.username.value),
              subtitle: CustomText(txt: "gmail100@gmail.com", size: 15.sp),
              leading: ComCont(
                givenPadd: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
                givenMarg: EdgeInsets.zero,
                withRadius: false,
                isCircular: true,
                withShadow: true,
                withBorder: true,
                kid: ReusedWidgets.getProfileImage(
                  width: 80,
                  isAvatar: _profileImageController.imagePicturePath.isEmpty,
                  avatarIndex: _profileImageController.imageAvatarIndex.isEmpty ? math.Random().nextInt(16)+1 : [1, 2].contains(_profileImageController.imageAvatarIndex.length) ? int.parse(_profileImageController.imageAvatarIndex)+1 : 1,
                  imageFilePath: _profileImageController.imagePicturePath
                ),
              )
            )
          ],          
        ),
      ),
    );
  }
}