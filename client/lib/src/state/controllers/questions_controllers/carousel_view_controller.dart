import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';

class QuestionsCarouselCtrler extends GetxController{
  var carouselController = CarouselController().obs;
  RxInt index = 0.obs;
  
  void changeCarouselIndex(int val){
    index.value = val;
  }

  void incrementIndex(){
    index.value = index.value + 1;
  }

  void goToNextPage(){
    carouselController.value.nextPage();
  }

  void goToPrevPage(){
    carouselController.value.previousPage();
  }
}