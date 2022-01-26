import 'package:client/src/app.dart';
import 'package:client/src/utils/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  setupLocator();
  runApp(const Quiziar());
}