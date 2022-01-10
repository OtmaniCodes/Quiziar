import 'package:get/get.dart';




class SIUsernameValidationController extends GetxController{
  var siUsernameValid = false.obs;

  void changeUsernameValidValidationState(bool val) => siUsernameValid.value = val;
}

class SIPasswordValidationController extends GetxController{
  var siPasswordValid = false.obs;

  void changePasswordValidationState(bool val) => siPasswordValid.value = val;
}

class UsernameValidationController extends GetxController{
  var usernameValid = false.obs;

  void changeUsernameValidValidationState(bool val) => usernameValid.value = val;
}

class PasswordValidationController extends GetxController{
  var passwordValid = false.obs;

  void changePasswordValidationState(bool val) => passwordValid.value = val;
}

class EmailValidationController extends GetxController{
  var emailValid = false.obs;

  void changeEmailValidationState(bool val) => emailValid.value = val;
}
