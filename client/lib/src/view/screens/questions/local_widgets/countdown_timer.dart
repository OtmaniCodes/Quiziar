import 'dart:async';

import 'package:client/src/state/controllers/questions_controllers/carousel_view_controller.dart';
import 'package:client/src/state/controllers/questions_controllers/countdown_animation_controller.dart';
import 'package:client/src/state/controllers/questions_controllers/selected_answer_controller.dart';
import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CountDownTimer extends StatefulWidget {
  const CountDownTimer({ Key? key }) : super(key: key);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> with SingleTickerProviderStateMixin {
  late Timer _timer;
  final CountDownAnimationController _countDownCtrler = Get.put(CountDownAnimationController());

  @override
  void initState() {
    _countDownCtrler.initController(AnimationController(vsync: this, duration: const Duration(seconds: 30), value: 1));
    _countDownCtrler.resetAnimation();
    animationInit();
    super.initState();
  }

  animationInit(){
    _countDownCtrler.startAnimation();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (timer) {
        if(Get.find<QuestionsCarouselCtrler>().index.value <= kQuestionsAmount){
          if(_countDownCtrler.seconds > 0){
            _countDownCtrler.decrementSeconds();
          }else{
            _countDownCtrler.resetSeconds();
            _countDownCtrler.resetAnimation();
            _countDownCtrler.startAnimation();
            //! save progress and go to next question
            if(Get.find<SelectedAnswerController>().selectedAnswers.value.length < kQuestionsAmount-1){
              Get.find<SelectedAnswerController>().addToSelectedAnswers({});
              Get.find<QuestionsCarouselCtrler>()..goToNextPage()..incrementIndex();
            }else{
              _countDownCtrler.resetSeconds();
              _countDownCtrler.resetAnimation();
              _timer.cancel();
              print("done with all questions 1");
            }
          }
        }else{
          _countDownCtrler.resetSeconds();
          _countDownCtrler.resetAnimation();
          _timer.cancel();
          print("done with all questions 2");
        }
      }
    );
  }

  @override
  void dispose() {
    _countDownCtrler.resetSeconds();
    _timer.cancel();
    if(_countDownCtrler.animationController != null){
      _countDownCtrler.animationController!.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CountDownAnimationController>(
      builder: (state){
        return AnimatedBuilder(
      animation: state.animationController!,
      child: CustomText(
        txt: state.seconds.toString().padLeft(2, '0')+"s",
        size: 15,
        isAnimted: true,
      ),
      builder: (context, Widget? child){
        return Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            ComCont(
              height: 25,
              withBorder: true,
              width: MediaQuery.of(context).size.width,
              givenMarg: EdgeInsets.zero,
              givenPadd: EdgeInsets.zero,
              kid: ReusedWidgets.spaceOut(),
            ),
            ComCont(
              givenMarg: const EdgeInsets.symmetric(horizontal: 2),
              givenPadd: EdgeInsets.zero,
              height: 21,
              bgColor: Theme.of(context).primaryColor,
              width: state.animationController!.value * MediaQuery.of(context).size.width,
              kid: ReusedWidgets.spaceOut(),
            ),
            ComCont(
              givenMarg: EdgeInsets.zero,
              givenPadd: const EdgeInsets.all(5.0),
              height: 40,
              width: 40,
              isCircular: true,
              withRadius: false,
              withBorder: true,
              kid: Center(
                child: child ?? ReusedWidgets.spaceOut(),
              )
            )
          ],
        );
      }
    );
      }
    );
  }
}