// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:client/src/state/controllers/form_validation_controller.dart';
import 'package:client/src/state/controllers/profile_image_controller.dart';
import 'package:client/src/state/controllers/theme.controller.dart';
import 'package:client/src/utils/helpers/logger.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

// my packages
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:client/src/state/controllers/signup_stepper_index.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/logo.dart';
import 'package:client/src/view/screens/onboarding/local_widgets/input_fields_form.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
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
    const int _stepsCount = 2;
    double _signFormHeight = 400.h;
    double _signFormWidth = 275.w;
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
                          Get.find<FormValidationController>().resetAll();
                        },
                        tabs: [
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
                          children: [
                            Center(
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ReusedWidgets.spaceOut(h: 50.h),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                                      child: OnboardingTextFieldsForm(formKey: _signInFormKey, showUsername: true, showPassword: true),
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
                                        Row(
                                          children: <Widget>[
                                            TextButton(
                                              onPressed: details.onStepCancel,
                                              child: Text('Back', style: TextStyle(color: _stepIndex > 0 ? Colors.blueAccent : Colors.grey),),
                                            ),
                                            ReusedWidgets.spaceOut(w: 10.w),
                                            ReusedWidgets.getMaterialButton(
                                              onPress: _stepIndex < _stepsCount ? details.onStepContinue : (){},
                                              bgColor: Theme.of(context).primaryColor,
                                              kid: Padding(
                                                padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
                                                child: const CustomText(txt: 'Next'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                  onStepTapped: (stepIndex){
                                    if (stepIndex >= 0 && stepIndex <= _stepsCount){
                                      state.setStepperStep(stepIndex);
                                    }
                                  },
                                  onStepContinue: (){
                                    List<GlobalKey<FormState>> _formKeys = [_signUp1FormKey, _signUp2FormKey];
                                    if (state.stepperStep < _stepsCount){
                                      if (state.stepperStep < 2){
                                        bool _validationResult = _formKeys[state.stepperStep].currentState!.validate();
                                        print(_validationResult);
                                        Get.find<FormValidationController>().changeFormValidation(!_validationResult, target: 'username') ;
                                      }
                                      // state.increment();
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
                                            OnboardingTextFieldsForm(formKey: _signUp1FormKey, showUsername: true, showEmail: true)
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
                                            OnboardingTextFieldsForm(formKey: _signUp2FormKey, showPassword: true)
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
                                                  withRadius: false,
                                                  isCircular: true,
                                                  givenPadd: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.w),
                                                  givenMarg: EdgeInsets.zero,
                                                  withShadow: true,
                                                  withBorder: true,
                                                  kid: GetBuilder<ProfileImageController>(
                                                    init: ProfileImageController(),
                                                    builder: (ProfileImageController state){
                                                      return CircleAvatar(
                                                        radius: 40,
                                                        backgroundImage: state.imagePicturePath.isNotEmpty
                                                          ? FileImage(File(state.imagePicturePath)) as ImageProvider
                                                          : AssetImage('assets/images/avatars/${state.imageAvatarIndex.isEmpty ? math.Random().nextInt(16)+1 : [1, 2].contains(state.imageAvatarIndex.length) ? int.parse(state.imageAvatarIndex)+1 : 'file path' }.png'),
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
                                            CustomText(txt: "Ahmed", size: 22.sp, fontFam: 'boldPoppins'),
                                            ReusedWidgets.spaceOut(h: 10.h),
                                            Row(
                                              children: [
                                                ReusedWidgets.getMaterialButton(
                                                  bgColor: Theme.of(context).primaryColor,
                                                  kid: Icon(Icons.camera_alt),
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
                                                  kid: Icon(Icons.image),
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
                                if (state.imagePicturePath.isEmpty) state.changeImagePicturePath('');
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
