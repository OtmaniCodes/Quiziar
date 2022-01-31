import 'dart:async';

import 'package:client/src/models/user.dart';
import 'package:get/get.dart';

class AuthStateController extends GetxController{
  StreamController<User>? streamController;
  bool controllerInited = false;

  void sinkUserInStream(User user){
    print(controllerInited);
    if(controllerInited) {
      streamController!.sink.add(user);
      update();
    }
  }

  init(){
    if (controllerInited == false){
      streamController = StreamController<User>();
      controllerInited = true;
      update();
    }
  }

  @override
  void dispose(){
    if(controllerInited){
      if(!streamController!.isClosed){
        print('state controller disposed');
        streamController!.close();
        streamController = null;
        controllerInited = false;
        update();
      }
    }
    super.dispose();
  }

  // Stream<User?> get getStream => streamController != null ? streamController!.stream : throw NullThrownError();

}