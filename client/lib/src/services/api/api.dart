import 'package:client/src/models/category.dart';
import 'package:client/src/models/question.dart';
import 'package:client/src/services/db/local_storage/local_storage.dart';
import 'package:client/src/utils/helpers/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/src/utils/constants/constansts.dart' as CONSTANTS;

class ApiService{
  Future<List<Category>> getAllCategories() async {
    List<Category> _questions = <Category>[];
    try {
      http.Response _response = await http.get(Uri.parse("${CONSTANTS.kTriviaQuestionsApiUrl}/api_category.php"));
      if(_response.statusCode == 200){
        _questions = (jsonDecode(_response.body)['trivia_categories'] as List).map((category) => Category.fromJson(category)).toList();
      }else{
        DevLogger.logError("Error fething categories from API");
      }
    } catch (e) {
      DevLogger.logError(e.toString(), cause: 'getQuestionsCategories');
    }
    return _questions;
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

  Future<List<Question>> getQuestionsByCategoryId(int categoryId) async {
    List<Question> _questions = <Question>[];
    try {
      // http.Response _response = await http.get(Uri.parse("${CONSTANTS.kTriviaQuestionsApiUrl}//api.php?amount=${CONSTANTS.kQuestionsAmount}&category=$categoryId&token=${LocalStorage().getUserID()}"));
      http.Response _response = await http.get(Uri.parse("${CONSTANTS.kTriviaQuestionsApiUrl}//api.php?amount=${CONSTANTS.kQuestionsAmount}&category=$categoryId"));
      if(_response.statusCode == 200){
        var _body = jsonDecode(_response.body);
        switch(_body['response_code']){
          case 0:
            _questions = (_body['results'] as List).map((question) => Question.fromJson(question)).toList();
            break;
          case 1:
            DevLogger.logError(" No Results Could not return results. The API doesn't have enough questions for your query. (Ex. Asking for 50 Questions in a Category that only has 20.)");
            break;
          case 2:
            DevLogger.logError("Invalid Parameter Contains an invalid parameter. Arguements passed in aren't valid. (Ex. Amount = Five)");
            break;
          case 3:
            DevLogger.logError("Token Not Found Session Token does not exist.");
            break;
          case 4:
            DevLogger.logError("Token Empty Session Token has returned all possible questions for the specified query. Resetting the Token is necessary.");
            //TODO: reset the token (API Docs)
            http.Response _response = await http.get(Uri.parse("${CONSTANTS.kTriviaQuestionsApiUrl}//api_token.php?command=reset&token=${LocalStorage().getUserID()}"));
            break;
        }
      }else{
        DevLogger.logError("Error fething questions based on category from API");
      }
    } catch (e) {
      DevLogger.logError(e.toString(), cause: 'getQuestionsByCategoryName');
    }
    return _questions;
  }
}