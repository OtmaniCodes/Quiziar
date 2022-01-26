import 'package:client/src/state/bindings/onboarding_binding.dart';
import 'package:client/src/state/controllers/theme.controller.dart';
import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:client/src/utils/theme/theming.dart';
import 'package:client/src/view/root.dart';
import 'package:client/src/view/screens/home/home.dart';
import 'package:client/src/view/screens/onboarding/onboarding.dart';
import 'package:client/src/view/screens/questions/questions.dart';
import 'package:client/src/view/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Quiziar extends StatelessWidget {
  const Quiziar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ThemeController()); //! initializes the theme controller (injects it)
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            SizeConfig(designHeight: 640, designWidth: 360).init(constraints, orientation);
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: kAppTitle,
              // theme: AppTheme().getTheme(),
              home: const RootScreen(),
              getPages: [
                GetPage(name: '/onboarding', page: () => const OnboardingScreen()),//, binding: OnboardingBinding()),
                GetPage(name: '/home', page: () => const HomeScreen()),
                GetPage(name: '/settings', page: () => const SettingsScreen(), transition: Transition.leftToRight),
                GetPage(name: '/questions', page: () => const QuestionsScreen())
              ],
            );
          }
        );
      }
    );
  }
}