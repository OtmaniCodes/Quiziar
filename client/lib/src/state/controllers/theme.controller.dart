import 'package:client/src/utils/prefs/prefs.dart';
import 'package:client/src/utils/theme/theming.dart';
import 'package:get/get.dart';

// 0 --> the default theme
// 1 --> the light theme
// 2 --> the dark (blackish) theme
class ThemeController extends GetxController{
  var themeIndex = 0.obs;

  /// call this method and pass it the theme index in order to chenge theme
  void changeTheme(int val){
    themeIndex.value = val;
    Get.changeTheme(AppTheme().getTheme(themeIndex.value));
    saveThemeIndexToLocalStorage(val);
  }

  @override
  void onInit() {
    themeIndex.value = getThemeIndexFromLocalStorage();
    Get.changeTheme(AppTheme().getTheme(themeIndex.value));
    super.onInit();
  }

  saveThemeIndexToLocalStorage(int themeIndex){
    LocalStorage().saveThemeOption(themeIndex);
  }

  int getThemeIndexFromLocalStorage() => LocalStorage().getThemeOption();
}