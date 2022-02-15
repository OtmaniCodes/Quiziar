import 'package:get/get.dart';

class AuthLoading extends GetxController{
  RxBool isLoading = false.obs;
  changeLoadingState(bool val){
    isLoading.value = val;
  }
}