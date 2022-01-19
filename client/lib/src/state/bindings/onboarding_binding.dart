// import 'package:client/src/state/controllers/onboarding_controllers/form_validation_controller.dart';
// import 'package:client/src/state/controllers/user_contollers/con_password.dart';
// import 'package:client/src/state/controllers/user_contollers/email.dart';
// import 'package:client/src/state/controllers/user_contollers/password.dart';
// import 'package:client/src/state/controllers/user_contollers/signin_password.dart';
// import 'package:client/src/state/controllers/user_contollers/signin_username.dart';
// import 'package:client/src/state/controllers/user_contollers/username.dart';
// import 'package:get/get.dart';

// class OnboardingBinding implements Bindings{

//   @override
//   void dependencies() {
//     //* gets data from fields
//     Get.lazyPut<SIUsernameController>(() => SIUsernameController());
//     Get.lazyPut<SIPasswordController>(() => SIPasswordController());
//     Get.lazyPut<UsernameController>(() => UsernameController());
//     Get.lazyPut<EmailController>(() => EmailController());
//     Get.lazyPut<PasswordController>(() => PasswordController());
//     Get.lazyPut<ConPasswordController>(() => ConPasswordController());
//     //* for validating that data
//     Get.lazyPut<SIUsernameValidationController>(() => SIUsernameValidationController());
//     Get.lazyPut<SIPasswordValidationController>(() => SIPasswordValidationController());
//     Get.lazyPut<UsernameValidationController>(() => UsernameValidationController());
//     Get.lazyPut<EmailValidationController>(() => EmailValidationController());
//     Get.lazyPut<PasswordValidationController>(() => PasswordValidationController());
//     Get.lazyPut<ConPasswordValidationController>(() => ConPasswordValidationController());
//   }

// }