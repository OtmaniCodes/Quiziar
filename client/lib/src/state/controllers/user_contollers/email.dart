import 'package:get/get.dart';

class EmailController extends GetxController{
  RxString email = ''.obs;

  void setEmail(String val){
    email.value = val;
  }
}