import 'package:get/get.dart';

class SelectedAnswerController extends GetxController{
  RxString selectedAnswer = ''.obs;
  RxList<Map<String, dynamic>> selectedAnswers = <Map<String, dynamic>>[].obs;

  void addToSelectedAnswers(Map<String, dynamic> val){
    selectedAnswers.add(val);
    print(selectedAnswers);
  }

  void updateSelectedAnswer(String val){
    selectedAnswer.value = val;
  }

}