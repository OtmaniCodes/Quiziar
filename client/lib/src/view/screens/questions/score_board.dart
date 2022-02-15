import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:client/src/models/answer.dart';
import 'package:client/src/services/db/local_storage/local_storage.dart';
import 'package:client/src/state/controllers/questions_controllers/selected_answer_controller.dart';
import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart' as animatedo;
import 'package:get/get.dart';


class ScoreBoared extends StatelessWidget {
  const ScoreBoared({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Answer> answers = Get.arguments ?? [];
    final int _correctAnswersCount = answers.where((answer) => answer.isCorrect).toList().length;
    final int _inCorrectAnswersCount = answers.where((answer) => !answer.isCorrect).toList().length;
    Table _getTable(String txt1, String txt2, String txt3){
      return Table(
        columnWidths: const {0: FractionColumnWidth(0.6), 1: FractionColumnWidth(0.3), 2: FractionColumnWidth(0.1),},
        children: <TableRow>[
          TableRow(
            children: [
              CustomText(txt: txt1, size: 17.sp, fontFam: 'boldPoppins'),
              CustomText(txt: txt2, size: 17.sp, fontFam: 'boldPoppins'),
              CustomText(txt: txt3, size: 17.sp, fontFam: 'boldPoppins'),
            ]
          )
        ],
      );
    }
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,  
          children: [
            animatedo.FadeInDown(child: const CongratSparkles()),
            ComCont(
              withShadow: true,
              bgColor: Theme.of(context).canvasColor.withOpacity(0.85),
              givenMarg: EdgeInsets.symmetric(horizontal: 40.w, vertical: 60.h),
              givenPadd: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              kid: Column(
                children: [
                  _getTable("Correct Answers", ":", _correctAnswersCount.toString().padLeft(2, '0')),
                  _getTable("Incorrect Answers", ":", _inCorrectAnswersCount.toString().padLeft(2, '0')),
                  ReusedWidgets.spaceOut(h: 20.h),
                  animatedo.ZoomIn(
                    child: Transform.rotate(
                      angle: -(pi / 10),
                      child: ComCont(
                        givenMarg: EdgeInsets.zero,
                        givenPadd: const EdgeInsets.all(10.0),
                        bgColor: Theme.of(context).canvasColor,
                        width: 120,
                        height: 120,
                        isCircular: true,
                        withRadius: false,
                        withBorder: true,
                        withShadow: true,
                        kid: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(txt: _correctAnswersCount.toString().padLeft(2, '0'), size: 30.sp,),
                              Container(
                                height: 3,
                                width: 60,
                                color: whiteClr,
                              ),
                              CustomText(txt: kQuestionsAmount.toString(),size: 30.sp,),
                            ],
                          )
                        ),
                      ),
                    ),
                  ),
                  ReusedWidgets.spaceOut(h: 20.h),
                  CustomText(txt: "Good Job!".toUpperCase(), fontFam: 'boldPoppins', size: 40.sp),
                  ReusedWidgets.spaceOut(h: 5.h),
                  CustomText(txt: "Right on ${LocalStorage().getUserName()}, You got $_correctAnswersCount x 10 = ${_correctAnswersCount * 10} points added to your score.\nKeep on learning.", alignment: TextAlign.center)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CongratSparkles extends StatefulWidget {
  const CongratSparkles({ Key? key }) : super(key: key);

  @override
  _CongratSparklesState createState() => _CongratSparklesState();
}

class _CongratSparklesState extends State<CongratSparkles> {
  late Timer _timer;
  final List<Sparkle> _sparkles = List.generate(300, (index) => Sparkle());

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1000 ~/ 60), (timer) {
      setState(() {
        _sparkles.forEach((sparkle) {
          sparkle.pos += Offset(sparkle.dx, sparkle.dy);
        });
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: CustomPaint(
        child: Container(),
        painter: SparklesCustomPaint(sparkles: _sparkles, drawCircle: true),
      ),
    );
  }
}

class Sparkle{
  late Offset pos;
  late double dx, dy, width, height;
  late Color color;
  Sparkle(){
    final double x = range(0, 400);
    final double y = range(0, 500);
    pos = Offset(x, y);
    dx = range(-0.1, 0.1);
    dy = range(-0.1, 0.1);
    width = 5.0;
    height = 20 * Random().nextDouble();
    color = Colors.white.withOpacity(Random().nextDouble());
  }

  double range(min, max) => Random().nextDouble() * (max - min) + min;
}

class SparklesCustomPaint extends CustomPainter{
  final bool drawCircle;
  final List<Sparkle> sparkles;
  SparklesCustomPaint({required this.sparkles, this.drawCircle = false});

  @override
  void paint(Canvas canvas, Size size) {
    sparkles.forEach((sparkle) {
      final _paint = Paint()..color = sparkle.color..style = PaintingStyle.fill;
      final Rect _rect = Rect.fromCenter(center: sparkle.pos, width: sparkle.width, height: sparkle.height);
      if(drawCircle){
        canvas.drawCircle(sparkle.pos, sparkle.height * 0.5, _paint);
      }else{
        canvas.drawRect(_rect, _paint);
      }
    });
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}