import 'dart:developer' as DEV;

class DevLogger{
  static logError(String error, {String? cause}){
    DEV.log(error, name: cause ?? 'Unknown');
  }
}