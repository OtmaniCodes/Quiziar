import 'package:get/get.dart';

class UsernameController extends GetxController{
  RxString username = ''.obs;

  void setUsername(String val){
    username.value = val;
  }
}