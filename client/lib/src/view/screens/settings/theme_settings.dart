import 'package:client/src/state/controllers/theme.controller.dart';
import 'package:client/src/utils/constants/enums.dart';
import 'package:client/src/utils/helpers/help_functions.dart';
import 'package:client/src/utils/theme/theming.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:flutter/material.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:get/get.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_outlined, color: Theme.of(context).iconTheme.color)
        ),
        backgroundColor: transClr,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        children: [
          const CustomText(txt: "Choose a theme you like."),
          ReusedWidgets.spaceOut(h: 30.h),
          ...List.generate(3, (index) => _buildThemeSelector(index))
        ],
      ),
    );
  }

  Widget _buildThemeSelector(int index){
    final List<String> _labels = ["Default Theme", "Light Theme" ,"Dark Theme"];
    return GetBuilder<ThemeController>(
      builder: (ThemeController state){
        final bool _isSelected = state.themeIndex == index;
        return ComCont(
          onTap: (){
            HelpFuncs.hapticFeedback(HapticIntensity.medium);
            state.changeTheme(index);
          },
          givenMarg: EdgeInsets.only(bottom: 15.h),
          givenPadd: EdgeInsets.zero,
          height: 100,
          roundingLevel: 10,
          withBorder: true,
          borderThickness: 1,
          borderColor: _isSelected ? Colors.green : whiteClr,
          bgColor: AppTheme.getSecondaryColor(index),
          kid: Align(
            alignment: Alignment.topCenter,
            child: ComCont(
              givenMarg: EdgeInsets.zero,
              givenPadd: EdgeInsets.zero,
              borderThickness: 1,
              borderColor: AppTheme.getPrimaryColor(index),
              withBorder: true,
              bgColor: AppTheme.getPrimaryColor(index),
              roundingLevel: 10,
              withShadow: true,
              height: 50,
              width: double.infinity,
              kid: Center(
                child: CustomText(
                  txt: _labels[index],
                  clr: whiteClr,
                  fontFam: 'boldPoppins',
                  size: 20.sp,
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}