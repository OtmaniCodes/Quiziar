import 'package:client/src/utils/constants/enums.dart';
import 'package:client/src/view/screens/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({ Key? key }) : super(key: key);

  Future<bool> _checkIfUserLoggedIn() async {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkIfUserLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> userStateSnap) {
        final bool authSnapLoaded = (userStateSnap.hasData && userStateSnap.connectionState == ConnectionState.done) ? userStateSnap.data != null : false;
        if(authSnapLoaded){
          bool userSnapData = userStateSnap.data!;
          AuthState _isAuthenticated = userSnapData ? AuthState.authenticated : AuthState.unAuthenticated; 
          switch(_isAuthenticated){
            case AuthState.authenticated:
              return Container();
            case AuthState.unAuthenticated:
              // Get.offNamed('/onboarding');
              return OnboardingScreen();
          }
        }else{
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}