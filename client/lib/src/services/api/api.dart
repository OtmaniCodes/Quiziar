import 'package:client/src/models/category.dart';
import 'package:client/src/utils/helpers/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/src/utils/constants/constansts.dart' as CONSTANTS;

class ApiService{
  Future<List<Category>> getAllCategories() async {
    List<Category> _categories = <Category>[];
    try {
      http.Response _response = await http.get(Uri.parse("${CONSTANTS.kTriviaQuestionsApiUrl}/api_category.php"));
      if(_response.statusCode == 200){
        _categories = (jsonDecode(_response.body)['trivia_categories'] as List).map((category) => Category.fromJson(category)).toList();
      }else{
        DevLogger.logError("Error fething categories from API");
      }
    } catch (e) {
      DevLogger.logError(e.toString(), cause: 'getQuestionsCategories');
    }
    return _categories;
  }

  Future<int> getCategoryQuestionsCount(int id) async {
    int _questionsCount = 0;
    try {
      http.Response _response = await http.get(Uri.parse("${CONSTANTS.kTriviaQuestionsApiUrl}/api_count.php?category=$id"));
      if(_response.statusCode == 200){
        _questionsCount = jsonDecode(_response.body)['category_question_count']['total_question_count'] as int; //! you can get the count of easy, medium and hard questions too!
      }else{
        DevLogger.logError("Error fething category questions count from API");
      }
    } catch (e) {
      DevLogger.logError(e.toString(), cause: 'getCategoryQuestionsCount');
    }
    return _questionsCount;
  }
}