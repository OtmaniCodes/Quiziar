import 'package:get/get.dart';

class SIUsernameController extends GetxController{
  RxString siUsername = ''.obs;

  void setSIUsername(String val){
    siUsername.value = val;
  }
}