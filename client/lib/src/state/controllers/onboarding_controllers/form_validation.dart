import 'package:get/get.dart';

class SIUsernameValidationController extends GetxController {
  var siUsernameValid = false.obs;
  var errorText = ''.obs;

  void changeErrorText(String val) => errorText.value = val;

  void changeUsernameValidationState(bool val) =>
      siUsernameValid.value = val;
}

class SIPasswordValidationController extends GetxController {
  var siPasswordValid = false.obs;
  var errorText = ''.obs;

  void changeErrorText(String val) => errorText.value = val;

  void changePasswordValidationState(bool val) => siPasswordValid.value = val;
}

class UsernameValidationController extends GetxController {
  var usernameValid = false.obs;
  var errorText = ''.obs;

  void changeErrorText(String val) => errorText.value = val;

  void changeUsernameValidValidationState(bool val) =>
      usernameValid.value = val;
}

class PasswordValidationController extends GetxController {
  var passwordValid = false.obs;
  var errorText = ''.obs;

  void changeErrorText(String val) => errorText.value = val;

  void changePasswordValidationState(bool val) => passwordValid.value = val;
}

class ConPasswordValidationController extends GetxController {
  var conPasswordValid = false.obs;
  var errorText = ''.obs;

  void changeErrorText(String val) => errorText.value = val;

  void changeConPasswordValidationState(bool val) =>
      conPasswordValid.value = val;
}

class EmailValidationController extends GetxController {
  var emailValid = false.obs;
  var errorText = ''.obs;

  void changeErrorText(String val) => errorText.value = val;

  void changeEmailValidationState(bool val) => emailValid.value = val;
}
