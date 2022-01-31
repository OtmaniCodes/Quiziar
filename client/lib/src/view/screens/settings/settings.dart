import 'package:client/src/models/user.dart';
import 'package:client/src/services/auth/auth.dart';
import 'package:client/src/services/db/local_storage/local_storage.dart';
import 'package:client/src/state/controllers/auth_state_controller.dart';
import 'package:client/src/state/controllers/profile_image_controller.dart';
import 'package:client/src/state/controllers/user_contollers/username.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/utils/helpers/logger.dart';
import 'package:client/src/utils/service_locator.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileImageController _profileImageController = Get.find<ProfileImageController>();
    final UsernameController _usernameCtler = Get.put(UsernameController()); 
    // final UsernameController _usernameCtler = Get.find<UsernameController>(); //!use this one 
    Widget _getSettingSection(int index){
      final List<String> _labels = ["Theme", "Language", "Notifications", "Sounds", "About us"];
      final List<IconData> _icons = [FontAwesomeIcons.brush, FontAwesomeIcons.globe,FontAwesomeIcons.bell, FontAwesomeIcons.volumeUp ,FontAwesomeIcons.question];
      return Column(
        children: [
          ListTile(
            onTap: (){
              switch(index){
                case 0:
                  Get.toNamed('/theme_settings');
                  break;
                case 1:
                  // go to languages screen
                  break;
                case 2:
                  // go to notifications screen
                  break;
                case 3:
                  // go to sounds screen
                  break;
                case 4:
                  // go to about us screen
                  break;
              }
            },
            leading: FaIcon(_icons[index]),
            title: CustomText(txt: _labels[index]),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
          ),
          Divider(
            height: 0.0,
            color: Theme.of(context).iconTheme.color?.withOpacity(0.25),
          ),
        ],
      );
    }
    final _localStorage = LocalStorage();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_outlined, color: Theme.of(context).iconTheme.color)
        ),
        backgroundColor: transClr,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          children: [
            ListTile(
              title: CustomText(txt: _localStorage.getUserName(), size: 20.sp, fontFam: 'boldPoppins'),//_usernameCtler.username.value),
              subtitle: CustomText(txt: _localStorage.getUserEmail(), size: 15.sp),
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
                  avatarIndex: int.parse(_profileImageController.imageAvatarIndex)+1,
                  imageFilePath: _profileImageController.imagePicturePath
                ),
              )
            ),
            ReusedWidgets.spaceOut(h: 40.h),
            ...List.generate(5, (index) => _getSettingSection(index)),
            ListTile(
              onTap: () async {
                try {
                  //! fix it
                  String _feedback = await locator<AuthService>().logout(uid: 'uid');
                  if(true){//_feedback == 'user is successfuly logged out'){
                    final LocalStorage _localStorage = LocalStorage();
                    _localStorage..saveUserID('')..saveUserName('')..saveUserEmail('');
                    Get.find<AuthStateController>().sinkUserInStream(User());
                    Get.back();
                    print("logged out");
                  }else{
                    ReusedWidgets.showNotiSnakBar(message: _feedback);
                  }
                } catch (e) {
                  DevLogger.logError(e.toString(), cause: "Signup form");
                }
              },
              title: CustomText(txt: "Log Out",),
            ),
            const Spacer(),
            CustomText(txt: "v1.0.0", clr: Theme.of(context).iconTheme.color?.withOpacity(0.5), size: 15.sp)
          ],          
        ),
      ),
    );
  }
}