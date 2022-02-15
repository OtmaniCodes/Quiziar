// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:client/src/services/auth/auth.dart';
import 'package:client/src/services/db/local_storage/local_storage.dart';
import 'package:client/src/state/controllers/onboarding_controllers/auth_loading.dart';
import 'package:client/src/state/controllers/onboarding_controllers/form_validation.dart';
import 'package:client/src/state/controllers/onboarding_controllers/signup_stepper_index.dart';
import 'package:client/src/state/controllers/profile_image_controller.dart';
import 'package:client/src/state/controllers/user_contollers/con_password.dart';
import 'package:client/src/state/controllers/user_contollers/email.dart';
import 'package:client/src/state/controllers/user_contollers/password.dart';
import 'package:client/src/state/controllers/user_contollers/signin_password.dart';
import 'package:client/src/state/controllers/user_contollers/signin_username.dart';
import 'package:client/src/state/controllers/user_contollers/username.dart';
import 'package:client/src/utils/constants/enums.dart';
import 'package:client/src/utils/helpers/help_functions.dart';
import 'package:client/src/utils/helpers/logger.dart';
import 'package:client/src/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

// my packages
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/logo.dart';
import 'package:client/src/view/screens/onboarding/local_widgets/input_fields_form.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage(BuildContext context, ImageSource imageSource) async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? _pickedImageFile = await _imagePicker.pickImage(source: imageSource);
    if(_pickedImageFile != null){
      Get.find<ProfileImageController>()
      ..changeProfileAvatarIndex('')
      ..changeImagePicturePath(_pickedImageFile.path);
    }
  }

  Future<bool> _askForStorageOrCameraPermission(BuildContext context, {bool permissionForCamera = true}) async {
    bool retVal = false;
    try {
      PermissionStatus _status = await (permissionForCamera ? Permission.camera : Permission.storage).request();
      if(_status == PermissionStatus.granted) retVal = true;      
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("your permission is needed in order to access your ${permissionForCamera ? "camera" : "storage"}.")));
    } catch (e) {
      DevLogger.logError(e.toString());
    }
    return retVal;
  }

  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signUp1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signUp2FormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //! use the following commented code instead of the one below it
    //! when you figure out how to deal with the onboarding issue
    // //* gets data from fields
    // final _siUsernameCtrler = Get.find<SIUsernameController>();
    // final _siPasswordCtrler = Get.find<SIPasswordController>();
    // final _usernameCtrler = Get.find<UsernameController>();
    // final _emailCtrler = Get.find<EmailController>();
    // final _passwordCtrler = Get.find<PasswordController>();
    // final _conPasswordCtrler = Get.find<ConPasswordController>();
    // //* for validating that data
    // final _siUsernameVaidatorCtrler = Get.find<SIUsernameValidationController>();
    // final _siPasswordVaidatorCtrler = Get.find<SIPasswordValidationController>();
    // final _usernameVaidatorCtrler = Get.find<UsernameValidationController>();
    // final _emailVaidatorCtrler = Get.find<EmailValidationController>();
    // final _passwordVaidatorCtrler = Get.find<PasswordValidationController>();
    // final _conPasswordVaidatorCtrler = Get.find<ConPasswordValidationController>();
    //* gets data from fields
    final _siUsernameCtrler = Get.put(SIUsernameController());
    final _siPasswordCtrler = Get.put(SIPasswordController());
    final _usernameCtrler = Get.put(UsernameController());
    final _emailCtrler = Get.put(EmailController());
    final _passwordCtrler = Get.put(PasswordController());
    final _conPasswordCtrler = Get.put(ConPasswordController());
    //* for validating that data
    final _siUsernameVaidatorCtrler = Get.put(SIUsernameValidationController());
    final _siPasswordVaidatorCtrler = Get.put(SIPasswordValidationController());
    final _usernameVaidatorCtrler = Get.put(UsernameValidationController());
    final _emailVaidatorCtrler = Get.put(EmailValidationController());
    final _passwordVaidatorCtrler = Get.put(PasswordValidationController());
    final _conPasswordVaidatorCtrler = Get.put(ConPasswordValidationController());
    const int _stepsCount = 2;
    double _signFormHeight = 400.h;
    double _signFormWidth = 275.w;
    final _authLoading = Get.put(AuthLoading());
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ReusedWidgets.spaceOut(h: 20.h),
                const AppLogo(),
                ReusedWidgets.spaceOut(h: 50.h),
                ComCont(
                  withShadow: true,
                  givenMarg: EdgeInsets.symmetric(horizontal: 20.w),
                  givenPadd: EdgeInsets.zero,
                  height: _signFormHeight,
                  width: _signFormWidth,
                  kid: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        indicatorColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(), 
                        unselectedLabelColor: whiteClr.withOpacity(0.75),
                        onTap: (index){
                          // if (_signTabViewIndexController.index != _tabController.index) _signTabViewIndexController.changeIndex(index);
                          // Get.find<FormValidationController>().resetAll();
                          if(index == 0){
                            _usernameCtrler.username.value = '';
                            _emailCtrler.email.value = '';
                            _passwordCtrler.password.value = '';
                            _conPasswordCtrler.conPassword.value = '';
                          } else {
                            _siUsernameCtrler.siUsername.value = '';
                            _siPasswordCtrler.siPassword.value = '';
                          }
                        },
                        tabs: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text('Sign in', style: TextStyle(fontSize: 18.sp))
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text('Sign Up', style: TextStyle(fontSize: 18.sp))
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            Center(
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ReusedWidgets.spaceOut(h: 50.h),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                                      child: OnboardingTextFieldsForm(
                                        formKey: _signInFormKey,
                                        showUsername: true,
                                        showPassword: true,
                                        onSubmit: () async {
                                          final bool _offline = await HelpFuncs.isAppOffline();
                                          if(_offline){
                                            ReusedWidgets.showNotiSnakBar(
                                              message: "There is no internet available, please check your wifi, mobile data...",
                                              icon: const Icon(Icons.warning),
                                            );
                                          }else{
                                            final bool _isValidated = _signInFormKey.currentState!.validate(); //? true if no errors 
                                            bool usernameValid = true;
                                            String usernameError = 'Please fill out this field.';
                                            bool passwordValid = true;
                                            String passwordError = 'Please fill out this field.';
                                            if(_siUsernameCtrler.siUsername.isEmpty){
                                              usernameValid = false;
                                              usernameError = 'Please fill out this field.';
                                            }else if(_siUsernameCtrler.siUsername.value.length < 5){
                                              usernameValid = false;
                                              usernameError = 'Please enter a username no less than 5 characters.';
                                            }
                                            if(_siPasswordCtrler.siPassword.isEmpty){
                                              passwordValid = false;
                                              passwordError = 'Please fill out this field.';
                                            }else if(_siPasswordCtrler.siPassword.value.length < 6){
                                              passwordValid = false;
                                              passwordError = 'Password should be at least 6 characters long.';
                                            }
                                            _siUsernameVaidatorCtrler.changeUsernameValidationState(!usernameValid);
                                            _siPasswordVaidatorCtrler.changePasswordValidationState(!passwordValid);
                                            if (_isValidated && usernameValid && passwordValid){
                                              HelpFuncs.hapticFeedback(HapticIntensity.medium);
                                              _signInFormKey.currentState!.save();
                                              try {
                                                _authLoading.changeLoadingState(true);
                                                ReusedWidgets.showNotiSnakBar(icon: SpinKitCircle(size: 30, color: whiteClr), message: "Please wait...", isPopable: false);
                                                String _feedback = await locator<AuthService>().loginWithUsernameAndPassword(username: _siUsernameCtrler.siUsername.value, password: _siPasswordCtrler.siPassword.value);
                                                _authLoading.changeLoadingState(false);
                                                Get.back();
                                                print(_feedback);
                                                if(_feedback == 'user is successfuly logged in'){
                                                  Get.offAllNamed("/home");
                                                }else{
                                                  ReusedWidgets.showNotiSnakBar(message: _feedback);
                                                }
                                              } catch (e) {
                                                DevLogger.logError(e.toString(), cause: "Signin form");
                                              }
                                            }else {
                                              _siUsernameVaidatorCtrler.changeErrorText(usernameError);
                                              _siPasswordVaidatorCtrler.changeErrorText(passwordError);
                                              HelpFuncs.hapticFeedback(HapticIntensity.vibrate, doubleHaptic: true);
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  ReusedWidgets.spaceOut(h: 20.h),
                                ],
                              ),
                            ),
                            GetBuilder<SignUpStepperIndexController>(
                              init: SignUpStepperIndexController(),
                              builder: (SignUpStepperIndexController state) {
                                return Stepper(
                                  currentStep: state.stepperStep,
                                  physics: const NeverScrollableScrollPhysics(),
                                  controlsBuilder: (BuildContext context, ControlsDetails details) {
                                    final int _stepIndex = details.stepIndex;
                                    return Column(
                                      children: [
                                        ReusedWidgets.spaceOut(h: 20.h),
                                        Obx(
                                          (){
                                            return Row(
                                              children: <Widget>[
                                                TextButton(
                                                  onPressed: !_authLoading.isLoading.value ? details.onStepCancel : null,
                                                  child: Text('Back', style: TextStyle(color: _stepIndex > 0 ? Colors.blueAccent : Colors.grey),),
                                                ),
                                                ReusedWidgets.spaceOut(w: 10.w),
                                                ReusedWidgets.getMaterialButton(
                                                  onPress: _stepIndex <= _stepsCount ? !_authLoading.isLoading.value ? details.onStepContinue : null : (){},
                                                  textColor: whiteClr.withOpacity(!_authLoading.isLoading.value ? 1 : 0.15),
                                                  bgColor: Theme.of(context).primaryColor,
                                                  kid: Padding(
                                                    padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
                                                    child: CustomText(txt: _stepIndex == 2 ? 'Done' : 'Next'),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        )
                                      ],
                                    );
                                  },
                                  onStepTapped: (stepIndex){
                                    if (stepIndex >= 0 && stepIndex <= _stepsCount){
                                      state.setStepperStep(stepIndex);
                                    }
                                  },
                                  onStepContinue: () async {
                                    final bool _offline = await HelpFuncs.isAppOffline();
                                    if(_offline){
                                      ReusedWidgets.showNotiSnakBar(
                                        message: "There is no internet available, please check your wifi, mobile data...",
                                        icon: const Icon(Icons.warning),
                                      );
                                    }else{
                                      if (state.stepperStep <= _stepsCount){
                                        if (state.stepperStep == 0){
                                          final bool _isValidated = _signUp1FormKey.currentState!.validate(); //? true if no errors 
                                          bool usernameValid = true;
                                          String usernameError = 'Please fill out this field.';
                                          bool emailValid = true;
                                          String emailError = 'Please fill out this field.';
                                          if(_usernameCtrler.username.isEmpty){
                                            usernameValid = false;
                                            usernameError = 'Please fill out this field.';
                                          }else if(_usernameCtrler.username.value.length < 5){
                                            usernameValid = false;
                                            usernameError = 'Please enter a username no less than 5 characters.';
                                          }
                                          if(_emailCtrler.email.isEmpty){
                                            emailValid = false;
                                            emailError = 'Please fill out this field.';
                                          }else if(!GetUtils.isEmail(_emailCtrler.email.value)){
                                            emailValid = false;
                                            emailError = 'Please enter a valid email address.';
                                          }
                                          _usernameVaidatorCtrler.changeUsernameValidValidationState(!usernameValid);
                                          _emailVaidatorCtrler.changeEmailValidationState(!emailValid);
                                          if (_isValidated && usernameValid && emailValid){
                                            HelpFuncs.hapticFeedback(HapticIntensity.medium);
                                            _signUp1FormKey.currentState!.save();
                                            if(FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
                                            state.increment();
                                          }else{
                                            _usernameVaidatorCtrler.changeErrorText(usernameError);
                                            _emailVaidatorCtrler.changeErrorText(emailError);
                                            HelpFuncs.hapticFeedback(HapticIntensity.vibrate, doubleHaptic: true);
                                          }
                                        }else if (state.stepperStep == 1){
                                          final bool _isValidated = _signUp2FormKey.currentState!.validate(); //? true if no errors 
                                          bool passwordValid = true;
                                          String passwordError = 'Please fill out this field.';
                                          bool conpasswordValid = true;
                                          String conpasswordError = 'Please fill out this field.';
                                          if(_passwordCtrler.password.isEmpty){
                                            passwordValid = false;
                                            passwordError = 'Please fill out this field.';
                                          }else if(_passwordCtrler.password.value.length < 6){
                                            passwordValid = false;
                                            passwordError = 'Password should be at least 6 characters long.';
                                          }
                                          if(_conPasswordCtrler.conPassword.isEmpty){
                                            conpasswordValid = false;
                                            conpasswordError = 'Please fill out this field.';
                                          }else if(_conPasswordCtrler.conPassword.value.length < 6){
                                            conpasswordValid = false;
                                            conpasswordError = 'Password should be at least 6 characters long.';
                                          }else if(_conPasswordCtrler.conPassword.value != _passwordCtrler.password.value){
                                            conpasswordValid = false;
                                            conpasswordError = 'passwords do not match.';
                                          }
                                          _passwordVaidatorCtrler.changePasswordValidationState(!passwordValid);
                                          _conPasswordVaidatorCtrler.changeConPasswordValidationState(!conpasswordValid);
                                          if (_isValidated && passwordValid && conpasswordValid){
                                            HelpFuncs.hapticFeedback(HapticIntensity.medium);
                                            _signUp2FormKey.currentState!.save();
                                            if(FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
                                            state.increment();
                                          }else{
                                            _passwordVaidatorCtrler.changeErrorText(passwordError);
                                            _conPasswordVaidatorCtrler.changeErrorText(conpasswordError);
                                            HelpFuncs.hapticFeedback(HapticIntensity.vibrate, doubleHaptic: true);
                                          }
                                        }else if (state.stepperStep == 2){
                                          try {
                                            _authLoading.changeLoadingState(true);
                                            ReusedWidgets.showNotiSnakBar(icon: SpinKitCircle(size: 30, color: whiteClr), message: "Please wait...", isPopable: false);
                                            String _feedback = await locator<AuthService>().registerWithUsernameAndPassword(
                                              username: _usernameCtrler.username.value,
                                              password: _passwordCtrler.password.value,
                                              email: _emailCtrler.email.value,
                                            );
                                            print(_feedback);
                                            _authLoading.changeLoadingState(false);
                                            Get.back();
                                            if(_feedback == 'user is successfuly registered'){
                                              final _profileImageCtler = Get.find<ProfileImageController>();
                                              String uid = LocalStorage().getUserID();
                                              String _uploadResult = '';
                                              if(_profileImageCtler.imagePicturePath.isNotEmpty){
                                                _uploadResult = await locator<AuthService>().uploadProfileImageFile(uid, _profileImageCtler.imagePicturePath);
                                              }else {
                                                _uploadResult = await locator<AuthService>().uploadProfileAvatarIndex(uid, int.parse(_profileImageCtler.imageAvatarIndex));
                                              }
                                              print(_uploadResult);
                                              Get.toNamed('/home'); //! should be Get.offAll...
                                            }else{
                                              ReusedWidgets.showNotiSnakBar(message: _feedback);
                                            }
                                          } catch (e) {
                                            DevLogger.logError(e.toString(), cause: "Signup form");
                                          }
                                        }
                                      }
                                    }
                                  },
                                  onStepCancel: (){
                                    if (state.stepperStep > 0){
                                      state.decrement();
                                    }
                                  },
                                  margin: EdgeInsets.zero,
                                  type: StepperType.horizontal,
                                  steps: <Step>[
                                    Step(
                                      isActive: state.stepperStep >= 0,
                                      state: state.stepperStep >= 0 ? StepState.complete : StepState.disabled,
                                      title: const Icon(Icons.person),
                                      content: SizedBox(
                                        height: _signFormHeight * 0.5,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            OnboardingTextFieldsForm(formKey: _signUp1FormKey, showUsername: true, showEmail: true, fromLogin: false)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Step(
                                      isActive: state.stepperStep >= 0,
                                      state: state.stepperStep >= 1 ? StepState.complete : StepState.disabled,
                                      title: const Icon(Icons.lock),
                                      content: SizedBox(
                                        height: _signFormHeight * 0.5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            OnboardingTextFieldsForm(formKey: _signUp2FormKey, showPassword: true, fromLogin: false)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Step(
                                      isActive: state.stepperStep >= 0,
                                      state: state.stepperStep >= 2 ? StepState.complete : StepState.disabled,
                                      title: const Icon(Icons.camera_alt),
                                      content: SizedBox(
                                        height: _signFormHeight * 0.5,
                                        child: Column(
                                          children: [
                                            // CustomText(txt: "Add a profile image"),
                                            Stack(
                                              alignment: AlignmentDirectional.topEnd,
                                              children: [
                                                ComCont(
                                                  givenPadd: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.w),
                                                  givenMarg: EdgeInsets.zero,
                                                  withRadius: false,
                                                  isCircular: true,
                                                  withShadow: true,
                                                  withBorder: true,
                                                  kid: GetBuilder<ProfileImageController>(
                                                    init: ProfileImageController(),
                                                    builder: (ProfileImageController state){
                                                      return ReusedWidgets.getProfileImage(
                                                        width: 80,
                                                        isAvatar: state.imagePicturePath.isEmpty,
                                                        imageFilePath: state.imagePicturePath,
                                                        avatarIndex: int.parse(state.imageAvatarIndex)+1
                                                      );
                                                    } 
                                                  ),
                                                ),
                                                ComCont(
                                                  onTap: _openOtherAvatarsPopup,
                                                  withBorder: true,
                                                  bgColor: Theme.of(context).primaryColor,
                                                  height: 30,
                                                  width: 30,
                                                  givenMarg: EdgeInsets.zero,
                                                  givenPadd: EdgeInsets.zero,
                                                  isCircular: true,
                                                  withRadius: false,
                                                  kid: const Icon(Icons.edit, size: 18)
                                                )
                                              ],
                                            ),
                                            CustomText(txt: _usernameCtrler.username.value, size: 22.sp, fontFam: 'boldPoppins'),
                                            ReusedWidgets.spaceOut(h: 10.h),
                                            Row(
                                              children: [
                                                ReusedWidgets.getMaterialButton(
                                                  bgColor: Theme.of(context).primaryColor,
                                                  kid: const Icon(Icons.camera_alt),
                                                  onPress: () async {
                                                    if (await _askForStorageOrCameraPermission(context)){
                                                      _pickProfileImage(context, ImageSource.camera);
                                                    }
                                                  },
                                                ),
                                                const Spacer(),
                                                const CustomText(txt: "Or"),
                                                const Spacer(),
                                                ReusedWidgets.getMaterialButton(
                                                  bgColor: Theme.of(context).primaryColor,
                                                  kid: const Icon(Icons.image),
                                                  onPress: () async {
                                                    if (await _askForStorageOrCameraPermission(context, permissionForCamera: false)){
                                                      _pickProfileImage(context, ImageSource.gallery);
                                                    }
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openOtherAvatarsPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return Material(
          color: transClr,
          child: GetBuilder<ProfileImageController>(
            init: ProfileImageController(),
            builder: (ProfileImageController state) {
              return Center(
                child: ComCont(
                  givenMarg: EdgeInsets.zero,
                  kid: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(txt: "Select an avatar that you like.", size: 20.h),
                      ReusedWidgets.spaceOut(h: 20.h),
                      Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        spacing: 10.h,
                        runSpacing: 10.h,
                        children: List.generate(16, (index) => ComCont(
                            withRadius: false,
                            isCircular: true,
                            givenPadd: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.w),
                            givenMarg: EdgeInsets.zero,
                            withShadow: true,
                            withBorder: true,
                            borderColor: [1, 2].contains(state.imageAvatarIndex.length) ? index == int.parse(state.imageAvatarIndex) ? Theme.of(context).primaryColor : whiteClr : whiteClr,
                            kid: GestureDetector(
                              onTap: () {
                                if (state.imagePicturePath.isNotEmpty) state.changeImagePicturePath('');
                                state.changeProfileAvatarIndex(index.toString());
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage('assets/images/avatars/${index+1}.png'),
                              ),
                            )
                          ),
                        ),
                      ),
                      ReusedWidgets.spaceOut(h: 20.h),
                      ReusedWidgets.getMaterialButton(
                        label: "Done",
                        bgColor: Theme.of(context).primaryColor,
                        onPress: (){
                          Get.back();
                        }
                      )
                    ],
                  )
                ),
              );
            }
          ),
        );
      }
    );
  }
}
