import 'package:client/src/utils/constants/enums.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class HelpFuncs{
  static hapticFeedback(HapticIntensity intensity, {bool doubleHaptic = false, int iterationsCount = 2}) async {
    if (!doubleHaptic){
      switch(intensity){
        case HapticIntensity.heavy:
          await HapticFeedback.heavyImpact();
          break;
        case HapticIntensity.light:
          await HapticFeedback.lightImpact();
          break;
        case HapticIntensity.medium:
          await HapticFeedback.mediumImpact();
          break;
        case HapticIntensity.vibrate:
          await HapticFeedback.vibrate();
          break;
      }
    } else {
      for (int i = 0; i < iterationsCount; i++){
        await Future.delayed(Duration(milliseconds: 100 * i), () => HapticFeedback.mediumImpact());
      }
    }
  }

  static Future<bool> isAppOffline() async {
    final ConnectivityResult _connectivityResult = await Connectivity().checkConnectivity();
    return _connectivityResult != ConnectivityResult.wifi && _connectivityResult != ConnectivityResult.mobile; 
  }
}