import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class OnboardingTextFieldsForm extends StatefulWidget {
  final bool showPassword;
  final bool showUsername;
  final bool showEmail;
  const OnboardingTextFieldsForm({Key? key, this.showPassword = false, this.showUsername = false, this.showEmail = false}) : super(key: key);

  @override
  _OnboardingTextFieldsFormState createState() => _OnboardingTextFieldsFormState();
}

class _OnboardingTextFieldsFormState extends State<OnboardingTextFieldsForm> {
  TextEditingController? _usernameController;
  TextEditingController? _passwordController;
  TextEditingController? _conPasswordController;
  TextEditingController? _emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children:[
              if (widget.showUsername) Padding(
                padding: EdgeInsets.only(bottom: 13.h),
                child: _buildTextField(hintText: 'Username', controller: _usernameController!, icon: Icons.person),
              ),
              if (widget.showEmail) Padding(
                padding: EdgeInsets.only(bottom: 13.h),
                child: _buildTextField(hintText: 'Email', controller: _emailController!, icon: Icons.email, inputType: TextInputType.emailAddress),
              ),
              if (widget.showPassword) Padding(
                padding: EdgeInsets.only(bottom: 13.h),
                child: _buildTextField(hintText: 'Password', controller: _passwordController!, isPassword: true, icon: Icons.lock, inputType: TextInputType.visiblePassword),
              ),
              if (widget.showPassword && !widget.showUsername) Padding(
                padding: EdgeInsets.only(bottom: 13.h),
                child: _buildTextField(hintText: 'Confirm password', controller: _conPasswordController!, isPassword: true, icon: Icons.lock, inputType: TextInputType.visiblePassword),
              ),
            ],
          ),
          if (widget.showUsername && widget.showPassword) _buildSubmitButton(context, label: 'Sign in')
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, {required String label}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          Expanded(
            child: MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(19.w, 10.h, 19.w, 10.h),
                child: CustomText(txt: label),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                print('hi');
              }, 
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
    bool isPassword = false}){
    return ComCont(
      withBorder: true,
      borderColor: transClr,
      roundingLevel: 40,
      givenPadd: EdgeInsets.fromLTRB(19.w, 2.h, 19.w, 2.h),
      givenMarg: EdgeInsets.symmetric(horizontal: 10.w),
      bgColor: Theme.of(context).scaffoldBackgroundColor,
      withShadow: true,
      kid: Row(
        children: [
          Icon(icon, color: whiteClr.withOpacity(0.15)),
          ReusedWidgets.spaceOut(w: 10.w),
          Expanded(
            child: TextFormField(
              maxLines: 1,
              obscureText: isPassword ? passwordOn : false,
              keyboardType: inputType ?? TextInputType.text,
              decoration: InputDecoration(
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