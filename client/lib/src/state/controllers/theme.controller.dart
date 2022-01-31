import 'package:client/src/services/db/local_storage/local_storage.dart';
import 'package:client/src/utils/theme/theming.dart';
import 'package:get/get.dart';

// 0 --> the default theme
// 1 --> the light theme
// 2 --> the dark (blackish) theme
class ThemeController extends GetxController{
  int themeIndex = 0;

  /// call this method and pass it the theme index in order to chenge theme
  void changeTheme(int val){
    themeIndex = val;
    Get.changeTheme(AppTheme().getTheme(val));
    saveThemeIndexToLocalStorage(val);
    update();
  }

  @override
  void onInit() {
    themeIndex = getThemeIndexFromLocalStorage();
    Get.changeTheme(AppTheme().getTheme(themeIndex));
    super.onInit();
  }

  void saveThemeIndexToLocalStorage(int themeIndex){
    LocalStorage().saveThemeOption(themeIndex);
  }

  int getThemeIndexFromLocalStorage() => LocalStorage().getThemeOption();
}