import 'package:client/src/state/controllers/onboarding_controllers/form_validation_controller.dart';
import 'package:client/src/state/controllers/user_contollers/email.dart';
// import 'package:client/src/state/controllers/onboarding_controllers/validations/password_validation.dart';
import 'package:client/src/state/controllers/user_contollers/password.dart';
import 'package:client/src/state/controllers/user_contollers/username.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingTextFieldsForm extends StatefulWidget {
  final bool fromLogin;
  final bool showPassword;
  final bool showUsername;
  final bool showEmail;
  final GlobalKey<FormState> formKey;
  final void Function()? onSubmit;
  const OnboardingTextFieldsForm({
    Key? key,
    this.fromLogin = true,
    required this.formKey,
    this.showPassword = false,
    this.showUsername = false,
    this.onSubmit,
    this.showEmail = false}) : super(key: key);

  @override
  _OnboardingTextFieldsFormState createState() => _OnboardingTextFieldsFormState();
}

class _OnboardingTextFieldsFormState extends State<OnboardingTextFieldsForm> {
  TextEditingController? _usernameController;
  TextEditingController? _passwordController;
  TextEditingController? _conPasswordController;
  TextEditingController? _emailController;

  @override
  void initState() {
    super.initState();
    if (widget.showPassword) _passwordController = TextEditingController();
    if (widget.showPassword && !widget.showUsername) _conPasswordController = TextEditingController();
    if (widget.showEmail) _emailController = TextEditingController();
    if (widget.showUsername) _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    if (widget.showPassword) _passwordController!.dispose();
    if (widget.showPassword && !widget.showUsername) _conPasswordController!.dispose();
    if (widget.showEmail) _emailController!.dispose();
    if (widget.showUsername) _usernameController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UsernameValidationController _usernameValidatorCtrler = Get.put(UsernameValidationController());
    final EmailValidationController _emailValidatorCtrler = Get.put(EmailValidationController());
    final _siPasswordVaidatorCtrler = Get.put(SIPasswordValidationController());
    final _siUsernameVaidatorCtrler = Get.put(SIUsernameValidationController());
    // final PasswordValidationController _passwordValidatorCtrler = Get.put(PasswordValidationController());
    return Form(
          key: widget.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children:[
                  if (widget.showUsername) Padding(
                    padding: EdgeInsets.only(bottom: 13.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(widget.fromLogin) Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 13.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTextField(hintText: 'Username', controller: _usernameController!, icon: Icons.person, onChanged: (text) => Get.find<UsernameController>().setUsername(text)),
                                  Obx(() => _siUsernameVaidatorCtrler.siUsernameValid.value ? const CustomText(txt: 'Please enter your username.', size: 13, clr: Colors.red,) : ReusedWidgets.spaceOut()),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 13.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTextField(hintText: 'Password', controller: _passwordController!, isPassword: true, icon: Icons.lock, inputType: TextInputType.visiblePassword, onChanged: (text) => Get.find<PasswordController>().setPassword(text)),
                                  Obx(() => _siPasswordVaidatorCtrler.siPasswordValid.value ? const CustomText(txt: "Enter your password.", size: 13, clr: Colors.red,) : ReusedWidgets.spaceOut())
                                ],
                              ),
                            ),
                          ],
                        ),





                        if(!widget.fromLogin) _buildTextField(hintText: 'Username', controller: _usernameController!, icon: Icons.person, onChanged: (text) => Get.find<UsernameController>().setUsername(text)),
                        if(!widget.fromLogin) Obx(() => _usernameValidatorCtrler.usernameValid.value ? const CustomText(txt: "username should not be blank or less than 4 letters.", size: 13, clr: Colors.red,) : ReusedWidgets.spaceOut())
                      ],
                    ),
                  ),
                  if (widget.showEmail && !widget.fromLogin) Padding(
                    padding: EdgeInsets.only(bottom: 13.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(hintText: 'Email', controller: _emailController!, icon: Icons.email, inputType: TextInputType.emailAddress, onChanged: (val) => Get.find<EmailController>().setEmail(val) ),
                        if(!widget.fromLogin) Obx(() => _emailValidatorCtrler.emailValid.value ? const CustomText(txt: "enter a valid email", size: 13, clr: Colors.red,) : ReusedWidgets.spaceOut())
                      ],
                    ), 
                  ),
                  if (widget.showPassword && !widget.fromLogin) Padding(
                    padding: EdgeInsets.only(bottom: 13.h),
                    child: _buildTextField(hintText: 'Password', controller: _passwordController!, isPassword: true, icon: Icons.lock, inputType: TextInputType.visiblePassword),
                  ),
                  if (widget.showPassword && !widget.showUsername && !widget.fromLogin) Padding(
                    padding: EdgeInsets.only(bottom: 13.h),
                    child: _buildTextField(hintText: 'Confirm password', controller: _conPasswordController!, isPassword: true, icon: Icons.lock, inputType: TextInputType.visiblePassword),
                  ),
                ],
              ),
              if (widget.showUsername && widget.showPassword) _buildSubmitButton(context, label: 'Sign in')
            ],
          ),
        );
    
    
    // GetBuilder<FormValidationController>(
    //   init: FormValidationController(),
    //   builder: (FormValidationController state) {
    //     return 
    //   }
    // );
  }

  Widget _buildSubmitButton(BuildContext context, {required String label}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          Expanded(
            child: ReusedWidgets.getMaterialButton(
              label: label,
              bgColor: Theme.of(context).primaryColor,
              givenPadd: EdgeInsets.fromLTRB(19.w, 10.h, 19.w, 10.h),
              onPress: widget.onSubmit ?? (){} 
            ), 
          ),
        ],
      ),
    );
  }

  bool passwordOn = true;
  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? inputType,
    void Function(String)? onChanged,
    bool isPassword = false}){
    return ComCont(
      withBorder: true,
      borderColor: transClr,
      roundingLevel: 40,
      givenPadd: EdgeInsets.fromLTRB(19.w, 2.h, 19.w, 2.h),
      givenMarg: EdgeInsets.zero,
      bgColor: Theme.of(context).scaffoldBackgroundColor,
      withShadow: true,
      kid: Row(
        children: [
          Icon(icon, color: whiteClr.withOpacity(0.15)),
          ReusedWidgets.spaceOut(w: 10.w),
          Expanded(
            child: TextFormField(
              validator: (String? text){
                if(text == null || text.isEmpty){
                  return "";
                }
                return null;
              },
              onChanged: onChanged,
              maxLines: 1,
              obscureText: isPassword ? passwordOn : false,
              keyboardType: inputType ?? TextInputType.text,
              decoration: InputDecoration(
                errorStyle: const TextStyle(height: 0),
                hintText: hintText,
                border: InputBorder.none
              ),
            ),
          ),
          isPassword
            ? GestureDetector(
              onTap: () => setState.call(() => passwordOn = !passwordOn),
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Icon(passwordOn ? Icons.visibility_off : Icons.visibility , color: whiteClr.withOpacity(0.5)),
                )
            ) : ReusedWidgets.spaceOut()
        ],
      )
    );
  }
}