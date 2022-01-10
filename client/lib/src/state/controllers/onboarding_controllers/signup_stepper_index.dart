import 'package:get/get.dart';

class SignUpStepperIndexController extends GetxController{
  int stepperStep = 0;

  void increment() {
    stepperStep += 1;
    update();
  }

  void decrement() {
    stepperStep -= 1 ;
    update();
  }

  void setStepperStep(int val){
    stepperStep = val;
    update();
  }
}