import 'package:client/src/models/answer.dart';
import 'package:get/get.dart';

class SelectedAnswerController extends GetxController{
  RxString selectedAnswer = ''.obs;
  var selectedAnswers = <Answer>[].obs;

  void addToSelectedAnswers(Answer val){
    selectedAnswers.add(val);
    print(val);
  }

  void updateSelectedAnswer(String val){
    selectedAnswer.value = val;
  }

}