import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:client/src/models/category.dart';
import 'package:client/src/models/question.dart';
import 'package:client/src/services/api/api.dart';
import 'package:client/src/state/controllers/questions_controllers/carousel_view_controller.dart';
import 'package:client/src/state/controllers/questions_controllers/countdown_animation_controller.dart';
import 'package:client/src/state/controllers/questions_controllers/selected_answer_controller.dart';
import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/utils/constants/enums.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/utils/helpers/help_functions.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:client/src/utils/service_locator.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:client/src/view/screens/questions/local_widgets/countdown_timer.dart';
import 'package:client/src/view/screens/questions/local_widgets/question_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionsScreen extends StatelessWidget {
  QuestionsScreen({ Key? key}) : super(key: key);
  // final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final QuestionsCarouselCtrler _carouselViewCtrler = Get.put(QuestionsCarouselCtrler());
    final SelectedAnswerController _selectedAnswerCtrler = Get.put(SelectedAnswerController());
    final Category _questionCategory = Get.arguments as Category;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: transClr,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_outlined, color: Theme.of(context).iconTheme.color)
        ),
        title: CustomText(
          txt: _questionCategory.name ?? '',
          fontFam: 'boldPoppins',
          size: 19.sp,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_outlined, color: Theme.of(context).iconTheme.color),
            onPressed: () {

            },
          ),
        ],
      ),
      body: FutureBuilder<List<Question>>(
        future: _questionCategory.id != null ? locator<ApiService>().getQuestionsByCategoryId(_questionCategory.id!) : null,
        builder: (BuildContext context, AsyncSnapshot<List<Question>> questionSnap){
          final bool _hasData = questionSnap.hasData ? questionSnap.data != null : false;
          if(_hasData){
            final List<Question> _questionData = questionSnap.data!;
            if(_questionData.isNotEmpty){
              return Obx((){
                return Column(
                  children: [
                    ReusedWidgets.spaceOut(h: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: const CountDownTimer(),
                    ),
                    ReusedWidgets.spaceOut(h: 10.h),
                    CarouselSlider.builder(
                      carouselController: _carouselViewCtrler.carouselController.value,
                      itemCount: _questionData.length,
                      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex){
                        return QuestionView(index: itemIndex, question: _questionData[itemIndex]);
                      },
                      options: CarouselOptions(
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        height: 430.h,
                        aspectRatio: 16/9,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      )
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Obx((){
                        
                        bool _answerChosen = _selectedAnswerCtrler.selectedAnswer.isNotEmpty;
                        return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusedWidgets.getMaterialButton(
                            bgColor: Theme.of(context).canvasColor,
                            label: 'Skip',
                            textColor: whiteClr.withOpacity(_carouselViewCtrler.index.value+1 < kQuestionsAmount ? 1 : 0.25),
                            givenPadd: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                            onPress: _carouselViewCtrler.index.value+1 < kQuestionsAmount ? (){
                              _selectedAnswerCtrler.addToSelectedAnswers({});
                              if(_selectedAnswerCtrler.selectedAnswer.isNotEmpty) _selectedAnswerCtrler.updateSelectedAnswer('');
                              Get.find<CountDownAnimationController>()
                                ..resetSeconds()..resetAnimation()..startAnimation();
                              _carouselViewCtrler..goToNextPage()..incrementIndex();
                            } : null
                          ),
                          SizedBox(width: 50, child: CustomText(alignment: TextAlign.center, txt: "${(_carouselViewCtrler.index.value+1).toString().padLeft(2, '0')}/$kQuestionsAmount")),
                          
                          
                          
                          
                          ReusedWidgets.getMaterialButton(
                            bgColor: Theme.of(context).primaryColor.withOpacity(_answerChosen ? 1 : 0.25),
                            label: _carouselViewCtrler.index.value+1 < kQuestionsAmount ? _selectedAnswerCtrler.selectedAnswers.length-1 == _carouselViewCtrler.index.value ? 'Next'  : 'Check' : _selectedAnswerCtrler.selectedAnswers.length == kQuestionsAmount ? "Validate" :"Check",
                            textColor: whiteClr.withOpacity(_answerChosen ? 1 : 0.25),
                            givenPadd: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h)

                            ,//!fix this shit
                            onPress: _carouselViewCtrler.index.value+1 < kQuestionsAmount
                              ? _answerChosen
                                ? (){
                                  // validate
                                  print('validate');
                                if(_selectedAnswerCtrler.selectedAnswers.length-1 == _carouselViewCtrler.index.value){
                                  _selectedAnswerCtrler.updateSelectedAnswer('');
                                  Get.find<CountDownAnimationController>()
                                  ..resetSeconds()..resetAnimation()..startAnimation();
                                  _carouselViewCtrler..goToNextPage()..incrementIndex();
                                }else{
                                final String _chosenAnswer = _selectedAnswerCtrler.selectedAnswer.value;
                                _selectedAnswerCtrler.addToSelectedAnswers(
                                  {"Answer": _chosenAnswer,
                                  "IsCorrect": _questionData[_carouselViewCtrler.index.value].incorrectAnswers!.contains(_chosenAnswer) == false});
                                }
                                } : null
                              : (){
                                if(_selectedAnswerCtrler.selectedAnswers.length == kQuestionsAmount){
                                  Get.find<CountDownAnimationController>()..resetSeconds()..resetAnimation();
                                  _selectedAnswerCtrler.updateSelectedAnswer('');
                                  Get.offNamed('/score_board');
                                }else{
                                   final String _chosenAnswer = _selectedAnswerCtrler.selectedAnswer.value;
                                  _selectedAnswerCtrler.addToSelectedAnswers(
                                  {"Answer": _chosenAnswer,
                                  "IsCorrect": _questionData[_carouselViewCtrler.index.value].incorrectAnswers!.contains(_chosenAnswer) == false});
                                }
                              }
                          )
                        ],
                      );
                      })
                    ),
                    ReusedWidgets.spaceOut(h: 10.h)
                  ],
                );
              });
            }else{
              return const Center(
                child: CustomText(txt: 'No Questions Available')
              );
            }
          }else{
            return Center(
              child: ReusedWidgets.showLoading(label: "Please wait...")
            );
          }
        }
      ),
    );
  }

 
}




