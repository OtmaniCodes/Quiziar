import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:client/src/utils/theme/theming.dart';
import 'package:client/src/view/root.dart';
import 'package:client/src/view/screens/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class Quiziar extends StatelessWidget {
  const Quiziar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            SizeConfig(designHeight: 640, designWidth: 360).init(constraints, orientation);
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: kAppTitle,
              theme: AppTheme().getTheme(),
              home: const RootScreen(),
              getPages: [
                GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
                GetPage(name: '/home', page: () => const OnboardingScreen())
              ],
            );
          }
        );
      }
    );
  }
}