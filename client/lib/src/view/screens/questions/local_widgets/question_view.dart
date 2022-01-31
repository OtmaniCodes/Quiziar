import 'package:client/src/models/question.dart';
import 'package:client/src/state/controllers/questions_controllers/carousel_view_controller.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:client/src/state/controllers/questions_controllers/selected_answer_controller.dart';
import 'package:client/src/utils/constants/enums.dart';
import 'package:client/src/utils/helpers/help_functions.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionView extends StatelessWidget {
  final int index;
  final Question question;
  QuestionView({ Key? key, required this.index, required this.question }) : super(key: key);
  int _selectedAnswer = -1;

  String getCleanText(String txt){
    final document = htmlParser.parse(txt);
    final String parsedString = htmlParser.parse(document.body!.text).documentElement!.text;
    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    final bool _isMultiple = question.type == 'multiple';
    List<String> _answers = [question.correctAnswer!, ...question.incorrectAnswers!].map((txt) => getCleanText(txt)).toList();
    _answers.shuffle();
    return ComCont(
      withShadow: true,
      givenMarg: EdgeInsets.symmetric(horizontal: 10.w),
      kid: Column(
        children: [
          CustomText(
            txt: getCleanText(question.question ?? ''),
            fontFam: 'semiBoldPoppins',
            alignment: TextAlign.center,
            size: 15.sp,
          ),
          const Spacer(),
          StatefulBuilder(
            builder: (context, onSetState) {
              return Column(
                children: List.generate(_answers.length,
                  (index) {  
                    final bool _isSelected = index == _selectedAnswer;
                    return _buildAnswersTile(context, index, _answers[index],
                    isSelected: _isSelected,
                    onTap: (){
                      if(!_isSelected) {
                        HelpFuncs.hapticFeedback(HapticIntensity.light);
                        onSetState(() => _selectedAnswer = index);
                        Get.find<SelectedAnswerController>().updateSelectedAnswer(_answers[index]);
                      }
                    });
                  },
                ),
              );
            }
          ),
        ],
      ),
    );
  }


  Widget _buildAnswersTile(BuildContext context, int index, String answerSuggestion, {void Function()? onTap, required bool isSelected}){
    final SelectedAnswerController _selectedAnswerController = Get.find<SelectedAnswerController>();
    final bool _isMyAnswerCorrect = question.incorrectAnswers!.contains(answerSuggestion) == false;
    // final bool _isAnswerChosen = [...question.incorrectAnswers!, question.correctAnswer!].contains(_selectedAnswer);
    return Obx((){
    // final String _selectedAnswer = _selectedAnswerController.selectedAnswer.value;
      final bool _areAnswersValidated = _selectedAnswerController.selectedAnswers.length-1 == Get.find<QuestionsCarouselCtrler>().index.value;
      return IgnorePointer(
        ignoring: _areAnswersValidated,
        child: ComCont(
        withAnimation: true,
        roundingLevel: 50,
        withBorder: true,
        bgColor: _areAnswersValidated
            ? _isMyAnswerCorrect
              ? Colors.green
              : isSelected
                ? Colors.red
                : null
            : isSelected
              ? Theme.of(context).primaryColor
              : null,
        givenPadd: EdgeInsets.zero,
        givenMarg: const EdgeInsets.only(bottom: 15),
        kid: ReusedWidgets.wrapWithInkEffect(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Row(
              children: [
                ComCont(
                  givenMarg: EdgeInsets.zero,
                  givenPadd: const EdgeInsets.all(5.0),
                  bgColor: Theme.of(context).primaryColor,
                  width: 30,
                  height: 30,
                  isCircular: true,
                  withRadius: false,
                  withBorder: true,
                  withShadow: true,
                  kid: Center(
                    child: Text(
                      (index+1).toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'boldPoppins',
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 3),
                            color: Colors.grey,
                            blurRadius: 5  
                          )
                        ]
                      ),
                    ),
                  ),
                ),
                ReusedWidgets.spaceOut(w: 10.w),
                Expanded(
                  child: CustomText(
                    txt: answerSuggestion,
                    isOverflow: true,
                  ),
                ),
              ],
            ),
          ),
          roundingLevel: 50,
          onTap: onTap
        ),
    ),
      );
    });
  }
}