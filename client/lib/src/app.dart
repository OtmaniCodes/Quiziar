import 'package:client/src/models/user.dart';
import 'package:client/src/services/auth/auth.dart';
import 'package:client/src/services/db/local_storage/local_storage.dart';
import 'package:client/src/state/controllers/auth_state_controller.dart';
import 'package:client/src/state/controllers/theme.controller.dart';
import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/utils/helpers/logger.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:client/src/view/screens/home/home.dart';
import 'package:client/src/view/screens/onboarding/onboarding.dart';
import 'package:client/src/view/screens/questions/questions.dart';
import 'package:client/src/view/screens/questions/score_board.dart';
import 'package:client/src/view/screens/settings/settings.dart';
import 'package:client/src/view/screens/settings/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Quiziar extends StatelessWidget {
  const Quiziar({ Key? key }) : super(key: key);

  void onStartUp(){
    final LocalStorage _localStorage = LocalStorage();
    Get.put(ThemeController());
    final AuthStateController _authStateCtrler = Get.put(AuthStateController());
    _authStateCtrler.init();
    try {
      final uid = _localStorage.getUserID();
      final username = _localStorage.getUserName();
      final email = _localStorage.getUserEmail();
      if(uid.isNotEmpty && username.isNotEmpty && email.isNotEmpty){
        // user is logged in
        //! check if profile image/index is on server (add it to user if it is)
        User _user = User(uid: uid, username: username, email: email);
        _authStateCtrler.sinkUserInStream(_user);
      }else{
        // user is not logged in
        _authStateCtrler.sinkUserInStream(User());
      }
      
    } catch (e) {
      DevLogger.logError(e.toString());
    }
    final bool _isVeryFirstLaunch = _localStorage.isAppFirstLaunch();
    if(_isVeryFirstLaunch){
      DevLogger.logError("Running for the very first time, ever.");
    }else{
      DevLogger.logError("already ran berfore, this is not first time.");
    }
  }

  @override
  Widget build(BuildContext context) {
    onStartUp.call();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            SizeConfig(designHeight: 640, designWidth: 360).init(constraints, orientation);
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: kAppTitle,
              // theme: AppTheme().getTheme(),
              home: HomeScreen(),// const RootScreen(), // ScoreBoared(),  //HomeScreen(),//
              getPages: [
                GetPage(name: '/onboarding', page: () => const OnboardingScreen()),//, binding: OnboardingBinding()),
                GetPage(name: '/home', page: () => const HomeScreen()),
                GetPage(name: '/questions', page: () => QuestionsScreen()),
                GetPage(name: '/score_board', page: () => const ScoreBoared()),
                GetPage(name: '/settings', page: () => const SettingsScreen(), transition: Transition.leftToRight),
                GetPage(name: '/theme_settings', page: () => const ThemeSettingsScreen()),
              ],
            );
          }
        );
      }
    );
  }
}