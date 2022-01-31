import 'package:client/src/models/user.dart';
import 'package:client/src/services/api/api.dart';
import 'package:client/src/services/auth/auth.dart';
import 'package:client/src/state/controllers/auth_state_controller.dart';
import 'package:client/src/utils/constants/enums.dart';
import 'package:client/src/utils/service_locator.dart';
import 'package:client/src/view/screens/home/home.dart';
import 'package:client/src/view/screens/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AuthStateController(),
      builder: (AuthStateController state){
        return StreamBuilder<User>(
          stream: state.controllerInited
            ? state.streamController!.stream
            : null,
          builder: (BuildContext context, AsyncSnapshot<User> userStateSnap){
            final bool _hasData = userStateSnap.hasData;
            if(_hasData){
              User userSnapData = userStateSnap.data!;
              AuthState _isAuthenticated = userSnapData.isNull ? AuthState.unAuthenticated : AuthState.authenticated; 
              switch(_isAuthenticated){
                case AuthState.authenticated:
                  return const HomeScreen();
                case AuthState.unAuthenticated:
                  // Get.offNamed('/onboarding');
                  return const OnboardingScreen();
              }
            }else{
              return const Center(child: CircularProgressIndicator());
            }
          }
        );
      },
    );
  }
}