import 'package:get/get.dart';

class FormValidationController extends GetxController{
  var usernameValid = false.obs;
  var emailValid = false.obs;
  var passwordValid = false.obs;
  var conPasswordValid = false.obs;

  void resetAll(){
    changeFormValidation(false, target: 'username');
    changeFormValidation(false, target: 'email');
    changeFormValidation(false, target: 'password');
    changeFormValidation(false, target: 'conpassword');
  }

  void changeFormValidation(bool val, {required String target}){
    if(target == 'username'){
      usernameValid.value = val;
    }else if(target == 'email'){
      emailValid.value = val;
    }else if(target == 'password'){
      passwordValid.value = val;
    }else if(target == 'conpassword'){
      conPasswordValid.value = val;
    }
  }
}