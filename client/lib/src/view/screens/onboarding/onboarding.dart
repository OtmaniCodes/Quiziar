import 'package:client/src/state/controllers/signup_stepper_index.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';

// my packages
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/logo.dart';
import 'package:client/src/view/screens/onboarding/local_widgets/input_fields_form.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:get/get.dart';

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

  @override
  Widget build(BuildContext context) {
    const int _stepsCount = 3;
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
                  height: 400.h,
                  width: 275.w,
                  kid: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        indicatorColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        unselectedLabelColor: whiteClr.withOpacity(0.75),
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
                                  const Expanded(child: OnboardingTextFieldsForm(showUsername: true, showPassword: true)),
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
                                            MaterialButton(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
                                                child: const CustomText(txt: 'Next'),
                                              ),
                                              color: Theme.of(context).primaryColor,
                                              onPressed: details.onStepContinue
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
                                    if (state.stepperStep < _stepsCount){
                                      state.increment();
                                    }
                                    // var f = Obx(() => state.stepperStep);
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
                                      content: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: const [
                                          OnboardingTextFieldsForm(showUsername: true, showEmail: true)
                                        ],
                                      ),
                                    ),
                                    Step(
                                      isActive: state.stepperStep >= 0,
                                      state: state.stepperStep >= 1 ? StepState.complete : StepState.disabled,
                                      title: const Icon(Icons.lock),
                                      content: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: const [
                                          OnboardingTextFieldsForm(showPassword: true)
                                        ],
                                      ),
                                    ),
                                    Step(
                                      isActive: state.stepperStep >= 0,
                                      state: state.stepperStep >= 2 ? StepState.complete : StepState.disabled,
                                      title: const Icon(Icons.camera_alt),
                                      content: Column(
                                        children: [
                                          const CircleAvatar(radius: 50,),
                                          const CustomText(txt: "Ahmed"),
                                          ElevatedButton(
                                            onPressed: (){},
                                            child:  CustomText(txt: "Change Avatar")
                                          ),
                                          ElevatedButton(
                                            onPressed: (){},
                                            child: CustomText(txt: "Change Avatar")
                                          ),
                                        ],
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
}
