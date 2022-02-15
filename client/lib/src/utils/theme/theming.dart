import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:flutter/material.dart';

class AppTheme{

  static Color getPrimaryColor(int themeIndex) => [proClr, proClr1, proClr2][themeIndex];
  static Color getSecondaryColor(int themeIndex) => [mainClr, mainClr1, mainClr2][themeIndex];
  static Color getCanvasColor(int themeIndex) => [secClr, secClr1, secClr2][themeIndex];

  TextStyle _textStyle({String fontFam = kFontFam, double fontsize = 16, bool isBold = false}) {
    return TextStyle(
      fontSize: fontsize,
      fontFamily: fontFam,
      color: whiteClr,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
  }

  TextTheme _getTextTheme() {
    return TextTheme(
      headline1: _textStyle(fontFam: kFontFam),
      headline2: _textStyle(),
      headline3: _textStyle(fontFam: kFontFam, isBold: true, fontsize: 25),
      headline4: _textStyle(fontFam: kFontFam, isBold: true, fontsize: 18),
      bodyText1: _textStyle(fontFam: kFontFam),
      bodyText2: _textStyle(fontsize: 15),
      caption: _textStyle(),
      overline: _textStyle(),
      subtitle1: _textStyle(),
      subtitle2: _textStyle(),
      button: _textStyle()).apply(bodyColor: whiteClr, fontFamily: kFontFam);
  }

  ThemeData getTheme(int themeIndex){
    return ThemeData(
      appBarTheme: AppBarTheme(centerTitle: true, backgroundColor: AppTheme.getCanvasColor(themeIndex), elevation: 0),
      primaryColor: AppTheme.getPrimaryColor(themeIndex),
      // accentColor: white,
      // colorScheme: ColorScheme.light(),
      iconTheme: IconThemeData(color: themeIndex == 1 ? blackClr : whiteClr),
      canvasColor: AppTheme.getCanvasColor(themeIndex),
      textTheme: _getTextTheme(),
      primaryTextTheme: _getTextTheme(),
      fontFamily: kFontFam,
      hintColor: Colors.grey.withOpacity(0.3),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        buttonColor: AppTheme.getPrimaryColor(themeIndex),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(whiteClr),
          shadowColor:  MaterialStateProperty.all(const Color(0xA3000000)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0))),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(textStyle: _textStyle())),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(textStyle: _textStyle())),
      // bottomSheetTheme: BottomSheetThemeData(
      //     backgroundColor: isDwhiteColor : whiteColor, elevation: 4),
      // highlightColor: transClr,
      // splashColor: transClr,
      textSelectionTheme: TextSelectionThemeData(cursorColor: AppTheme.getPrimaryColor(themeIndex), selectionColor: whiteClr.withOpacity(0.15), selectionHandleColor: whiteClr),
      // backgroundColor: isDark ? darkMainColor : lightMainColor,
      // unselectedWidgetColor: whiteColor,
      scaffoldBackgroundColor: AppTheme.getSecondaryColor(themeIndex),
      brightness: Brightness.dark,
      visualDensity: VisualDensity.comfortable,
      // inputDecorationTheme: InputDecorationTheme(
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(15),
        // ),
        // filled: true,
        // fillColor: AppTheme.getSecondaryColor(themeIndex),
        // focusColor: whiteClr,
        // hintStyle: TextStyle(color: whiteClr.withOpacity(0.15)),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: whiteClr, width: 3.0),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: whiteClr(color: whiteClr, width: 3.0),
        // ),
      // ),
    );
  }

}