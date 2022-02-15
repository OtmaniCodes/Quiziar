import 'package:client/src/state/controllers/onboarding_controllers/auth_loading.dart';
import 'package:client/src/state/controllers/onboarding_controllers/form_validation.dart';
import 'package:client/src/state/controllers/user_contollers/con_password.dart';
import 'package:client/src/state/controllers/user_contollers/email.dart';
import 'package:client/src/state/controllers/user_contollers/password.dart';
import 'package:client/src/state/controllers/user_contollers/signin_password.dart';
import 'package:client/src/state/controllers/user_contollers/signin_username.dart';
import 'package:client/src/state/controllers/user_contollers/username.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart' as animatedo;


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
    final _siPasswordVaidatorCtrler = Get.find<SIPasswordValidationController>();
    final _siUsernameVaidatorCtrler = Get.find<SIUsernameValidationController>();
    final _usernameValidatorCtrler = Get.find<UsernameValidationController>();
    final _emailValidatorCtrler = Get.find<EmailValidationController>();
    final _passwordVaidatorCtrler = Get.put(PasswordValidationController());
    final _conPasswordVaidatorCtrler = Get.put(ConPasswordValidationController());
    // Widget _buildValidFormWidget({required Widget dataEntry, required bool errorCondition, required String errorText}){
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       dataEntry,
    //       Obx(() => errorCondition ? CustomText(txt: errorText, size: 13, clr: Colors.red) : ReusedWidgets.spaceOut()),
    //     ],
    //   );
    // }
    Widget _getError(String txt) => Padding(padding: const EdgeInsets.only(left: 15), child: animatedo.ElasticIn(child: CustomText(txt: txt, size: 13, clr: Colors.red)));
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
                                  // _buildValidFormWidget(
                                  //   dataEntry: _buildTextField(hintText: 'Username', controller: _usernameController!, icon: Icons.person, onChanged: (text) => Get.find<SIUsernameController>().setSIUsername(text)), 
                                  //   errorCondition: _siUsernameVaidatorCtrler.siUsernameValid.value,
                                  //   errorText: "Please enter your username." 
                                  // )
                                  _buildTextField(hintText: 'Username', controller: _usernameController!, icon: Icons.person, onChanged: (text) => Get.find<SIUsernameController>().setSIUsername(text)),
                                  Obx(() => _siUsernameVaidatorCtrler.siUsernameValid.value ? _getError(_siUsernameVaidatorCtrler.errorText.value) : ReusedWidgets.spaceOut()),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 13.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTextField(hintText: 'Password', controller: _passwordController!, isPassword: true, icon: Icons.lock, inputType: TextInputType.visiblePassword, onChanged: (text) => Get.find<SIPasswordController>().setSIPassword(text)),
                                  Obx(() => _siPasswordVaidatorCtrler.siPasswordValid.value ? _getError(_siPasswordVaidatorCtrler.errorText.value) : ReusedWidgets.spaceOut())
                                ],
                              ),
                            ),
                          ],
                        ),
                        if(!widget.fromLogin)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(hintText: 'Username', controller: _usernameController!, icon: Icons.person, onChanged: (text) => Get.find<UsernameController>().setUsername(text)),
                            Obx(() => _usernameValidatorCtrler.usernameValid.value ? _getError(_usernameValidatorCtrler.errorText.value) : ReusedWidgets.spaceOut())
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (widget.showEmail && !widget.fromLogin) Padding(
                    padding: EdgeInsets.only(bottom: 13.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(hintText: 'Email', controller: _emailController!, icon: Icons.email, inputType: TextInputType.emailAddress, onChanged: (val) => Get.find<EmailController>().setEmail(val)),
                        if(!widget.fromLogin) Obx(() => _emailValidatorCtrler.emailValid.value ? _getError(_emailValidatorCtrler.errorText.value) : ReusedWidgets.spaceOut())
                      ],
                    ), 
                  ),
                  if (widget.showPassword && !widget.fromLogin) Padding(
                    padding: EdgeInsets.only(bottom: 13.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(hintText: 'Password', controller: _passwordController!, isPassword: true, icon: Icons.lock, inputType: TextInputType.visiblePassword, onChanged: (val) => Get.find<PasswordController>().setPassword(val)),
                        Obx(() => _passwordVaidatorCtrler.passwordValid.value ? _getError(_passwordVaidatorCtrler.errorText.value) : ReusedWidgets.spaceOut())
                      ],
                    ),
                  ),
                  if (widget.showPassword && !widget.showUsername && !widget.fromLogin) Padding(
                    padding: EdgeInsets.only(bottom: 13.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(hintText: 'Confirm password', controller: _conPasswordController!, isPassword: true, icon: Icons.lock, inputType: TextInputType.visiblePassword, onChanged: (val) => Get.find<ConPasswordController>().setConPassword(val)),
                        Obx(() => _conPasswordVaidatorCtrler.conPasswordValid.value ? _getError(_conPasswordVaidatorCtrler.errorText.value) : ReusedWidgets.spaceOut())
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.showUsername && widget.showPassword) _buildSubmitButton(context, label: 'Sign in')
            ],
          ),
        );
  }

  Widget _buildSubmitButton(BuildContext context, {required String label}) {
    final _authLoading = Get.find<AuthLoading>();
    return Obx(
        () {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            children: [
              Expanded(
                child: ReusedWidgets.getMaterialButton(
                  label: label,
                  textColor: whiteClr.withOpacity(!_authLoading.isLoading.value ? 1 : 0.15),
                  bgColor: Theme.of(context).primaryColor,
                  givenPadd: EdgeInsets.fromLTRB(19.w, 10.h, 19.w, 10.h),
                  onPress: !_authLoading.isLoading.value ? widget.onSubmit ?? (){} : null 
                ), 
              ),
            ],
          ),
        );
      }
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
          //TODO: password and confirm password fields get obsecured simultanously!
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