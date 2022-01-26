import 'package:client/src/models/category.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController{
  List<Category> categories = [];
  void setCategories(List<Category> val){
    categories = val;
  }
}