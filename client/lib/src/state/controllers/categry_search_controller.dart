import 'package:get/get.dart';

class CategorySearchController extends GetxController{
  String searchTerm = '';
  bool isSearch = false;
  updateSearchTerm(String val){
    searchTerm = val;
    update();
  }

  toggleSearchState(){
    isSearch = !isSearch;
    update();
  }
}