import 'package:get/get.dart';

class SIPasswordController extends GetxController{
  RxString siPassword = ''.obs;

  void setSIPassword(String val){
    siPassword.value = val;
  }
}