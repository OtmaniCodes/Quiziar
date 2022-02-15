import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:client/src/models/user.dart';
import 'package:client/src/services/db/local_storage/local_storage.dart';
import 'package:client/src/state/controllers/auth_state_controller.dart';
import 'package:client/src/utils/constants/constansts.dart' as CONSTANTS;
import 'package:client/src/utils/helpers/logger.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

abstract class AuthTemplate{
  
  // Stream<User?> get getStream;
  Future loginWithUsernameAndPassword({required String username, required String password});
  Future registerWithUsernameAndPassword({required String username, required String email, required String password});
  Future logout({required String uid});
  Future deleteUserPermanently({required String uid});
}

class AuthService extends AuthTemplate{
 
  @override
  Future<String> loginWithUsernameAndPassword({required String username, required String password}) async {
    String _retMessage = 'error';
    Map<String, String> _body = {
      "username": username,
      "password": password
    };
    try {
      http.Response _loginRequest = await http.post(Uri.parse(CONSTANTS.kDebugServerUrl+"/api/user/login"), body: _body);
      if(_loginRequest.statusCode == 200){
        Map<String, dynamic> _data = jsonDecode(_loginRequest.body);
        if(_data['isSuccess']){
          User user = User.fromJson(_data['data']);
          if(user.uid != null && user.username != null && user.email != null){
            LocalStorage()
            ..saveUserID(user.uid!)
            ..saveUserName(user.username!)
            ..saveUserEmail(user.email!);
            Get.find<AuthStateController>().sinkUserInStream(user);
            _retMessage = _data["message"];
          }else{
            throw NullThrownError();
          }
        }else{
          _retMessage = _data['message'];
        }
      }else{
        DevLogger.logError("Error code: ${_loginRequest.statusCode}", cause: 'loginWithUsernameAndPassword');  
      } 
    } catch (e) {
      DevLogger.logError(e.toString(), cause: 'loginWithUsernameAndPassword');
    }
    return _retMessage;
  }

  @override
  Future<String> registerWithUsernameAndPassword({required String username, required String email, required String password}) async {
    String _retMessage = 'error';
    Map<String, String> _body = {
      "username": username,
      "email": email,
      "password": password
    };
    try {
      http.Response _registerRequest = await http.post(Uri.parse(CONSTANTS.kDebugServerUrl+"/api/user/register"), body: _body);
      if(_registerRequest.statusCode == 200){
        Map<String, dynamic> _data = jsonDecode(_registerRequest.body);
        if(_data['isSuccess']){
          User newUser = User.fromJson(_data['data']);
          if(newUser.uid != null && newUser.username != null && newUser.email != null){
            LocalStorage()
              ..saveUserID(newUser.uid!)
              ..saveUserName(newUser.username!)
              ..saveUserEmail(newUser.email!);
            Get.find<AuthStateController>().sinkUserInStream(newUser);
            _retMessage = _data["message"];
          }else{
            throw NullThrownError();
          }
        }else{
          _retMessage = _data['message'];
        }
      }
    } catch (e) {
      DevLogger.logError(e.toString(), cause: 'registerWithUsernameAndPassword');
    }
    return _retMessage;
  }

  Future uploadProfileImageFile(String uid, String imageFilePath) async {
    String _retMessage = 'error';
    File _file = File(imageFilePath);
    List<int> bytes = _file.readAsBytesSync();
    String img64 = base64Encode(bytes);
    Map<String, String> _body = {
      "uid": uid,
      "photo_file": img64,
    };
    try {
      http.Response _photoUploadRequest = await http.post(Uri.parse(CONSTANTS.kDebugServerUrl+"/api/user/update-profile-image"), body: _body);
      if(_photoUploadRequest.statusCode == 200){
        Map<String, dynamic> _data = jsonDecode(_photoUploadRequest.body);
        if(_data['isSuccess']){  
          //TODO do something (you got a 64base image, get the path from it and give it to the corresponding controller)
        }
        _retMessage = _data['message'];
      }
    } catch (e) {
      DevLogger.logError(e.toString(), cause: 'registerWithUsernameAndPassword');
    }
    return _retMessage;
  }

  Future uploadProfileAvatarIndex(String uid, int index) async {

  }

  @override
  Future<String> logout({required String uid}) async {
    String _retMessage = 'error';
    try {
      //TODO: log out the user in the server
    } catch (e) {
      DevLogger.logError(e.toString(), cause: 'logout');
    }
    return _retMessage;
  }

  @override
  Future deleteUserPermanently({required String uid}) {
    // TODO: implement deleteUserPermanently
    throw UnimplementedError();
  }

}