import 'dart:async';
import 'dart:convert';
import 'package:client/src/models/user.dart';
import 'package:client/src/services/db/local_storage/local_storage.dart';
import 'package:client/src/utils/constants/constansts.dart' as CONSTANTS;
import 'package:client/src/utils/helpers/logger.dart';
import 'package:http/http.dart' as http;

abstract class AuthTemplate{
  
  // Stream<User?> get getStream;
  Future loginWithUsernameAndPassword({required String username, required String password});
  Future registerWithUsernameAndPassword({required String username, required String email, required String password});
  Future logout({required String uid});
  Future deleteUserPermanently({required String uid});
}



class AuthService extends AuthTemplate{
  StreamController<User?>? _streamController;
  bool _controllerInited = false;

  init(){
    if (_controllerInited == false){
      _streamController ??= StreamController<User?>();
      _controllerInited = true;
    }
  }

  dispose(){
    if(_streamController != null){
      if(!_streamController!.isClosed){
        _streamController!.close();
        _controllerInited = false;
      }
    }
  }

  Stream<User?> get getStream => _streamController != null ? _streamController!.stream : throw NullThrownError();

  @override
  Future loginWithUsernameAndPassword({required String username, required String password}) async {
    Map<String, String> _body = {
      "username": username,
      "password": password
    };
    try {
      http.Response _loginRequest = await http.post(Uri.parse(CONSTANTS.kDebugServerUrl), body: _body);
      if(_loginRequest.statusCode == 200){
        Map<String, dynamic> _data = jsonDecode(_loginRequest.body);
        if(_data['isSuccess']){
          User user = User.fromJson(_data['data']);
          if(user.uid != null){
            LocalStorage().saveUserID(user.uid!);
            if(_controllerInited) _streamController!.sink.add(user);
            return _data["message"];
          }else{
            throw NullThrownError();
          }
        }
      }
    } catch (e) {
      DevLogger.logError(e.toString(), cause: 'loginWithUsernameAndPassword');
    }
  }

  @override
  Future registerWithUsernameAndPassword({required String username, required String email, required String password}) async {
    Map<String, String> _body = {
      "username": username,
      "email": email,
      "password": password
    };
    try {
      http.Response _registerRequest = await http.post(Uri.parse(CONSTANTS.kDebugServerUrl), body: _body);
      if(_registerRequest.statusCode == 200){
        Map<String, dynamic> _data = jsonDecode(_registerRequest.body);
        if(_data['isSuccess']){
          User newUser = User.fromJson(_data['data']);
          if(newUser.uid != null){
            LocalStorage().saveUserID(newUser.uid!);
            if(_controllerInited) _streamController!.sink.add(newUser);
            return _data["message"];
          }else{
            throw NullThrownError();
          }
        }
      }

    } catch (e) {
      DevLogger.logError(e.toString(), cause: 'registerWithUsernameAndPassword');
    }
  }

  @override
  Future logout({required String uid}) {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future deleteUserPermanently({required String uid}) {
    // TODO: implement deleteUserPermanently
    throw UnimplementedError();
  }

}