import 'package:get/get.dart';

class ProfileImageController extends GetxController{
  String imageAvatarIndex = '1';
  String imagePicturePath = '';

  void changeProfileAvatarIndex(String val){
    imageAvatarIndex = val;
    update();
  }

  void changeImagePicturePath(String val){
    imagePicturePath = val;
    update();
  }
} 