import 'package:get/get.dart';

class PasswordController extends GetxController{
  RxString password = ''.obs;

  void setPassword(String val){
    password.value = val;
  }
}