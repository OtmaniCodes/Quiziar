import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountDownAnimationController extends GetxController{
  AnimationController? animationController;
  int seconds = 30;
  
  void decrementSeconds(){
    seconds -= 1;
    update();
  }

  void resetSeconds(){
    seconds = 30;
    update();
  }

  void initController(AnimationController anim){
    animationController = anim;
    update();
  }

  void startAnimation(){
    if(animationController != null){
      animationController!.forward();
      update();
    }
  }

  void reverseAnimation(){
    if(animationController != null){
      animationController!.reverse();
      update();
    }
  }

  void stopAnimation(){
    if(animationController != null){
      animationController!.stop();
      update();
    }
  }

  void resetAnimation(){
    if(animationController != null){
      animationController!.reset();
      update();
    }
  }

  @override
  void onClose() {
    print("closed");
    if(animationController != null){
      animationController = null;
      update();
    }
    super.onClose();
  }

  @override
  void dispose() {
    print("disposed 2");
    if(animationController != null){
      animationController = null;
      update();
    }
    super.dispose();
  }
}