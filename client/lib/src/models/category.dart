import 'dart:convert';

import 'package:client/src/utils/helpers/logger.dart';

class Category{
  int? id;
  String? name;

  Category({ this.id, this.name});

  Category.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson(){
    void isNull(object) {
      if(object == null) {
        DevLogger.logError('$object is null', cause: 'Category Model, toJson()');
        throw NullThrownError();
      }
    }
    isNull(id);
    isNull(name);
    return {
      'id': id,
      'name': name
    };
  }
}