import 'package:get/get.dart';

class ConPasswordController extends GetxController{
  RxString conPassword = ''.obs;

  void setConPassword(String val){
    conPassword.value = val;
  }
}