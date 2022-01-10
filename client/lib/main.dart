import 'package:client/src/app.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

main() async {
  await GetStorage.init(); // should be awaited for
  runApp(const Quiziar());
}