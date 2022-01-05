import 'package:flutter/material.dart';

class SizeConfig{
  final double designWidth;
  final double designHeight;
  SizeConfig({
    required this.designHeight,
    required this.designWidth
  });

  static double? screenWidth;
  static double? screenHeight;
  static double? blocWidthMultiplier;
  static double? blocHeightMultiplier;
  static double? blocTextMultiplier;
  static bool? isMobilePortrait;
  static bool? isPortrait;

  // static bool isMobile() => isPortrait! ? screenWidth! <= kMobileBP : screenHeight! <= kMobileBP;
  // static bool isDesktop() => isPortrait! ? screenWidth! > kMobileBP : screenHeight! > kMobileBP && isMobile() == false;
  // static bool isDesktopMQ(BuildContext context) => MediaQuery.of(context).size.width > kMobileBP && isMobile() == false;


  void init(BoxConstraints constraints, Orientation orientation){
    if(orientation == Orientation.portrait){
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      isPortrait = true;
    if((screenWidth ?? 360) < 480){
      isMobilePortrait = true;
    }else{
      isMobilePortrait = false;
    }
    }else{
      screenHeight = constraints.maxWidth;
      screenWidth = constraints.maxHeight;
      isMobilePortrait = false;
      isPortrait = false;
    }
    blocWidthMultiplier = (screenWidth ?? 360) / designWidth;
    blocTextMultiplier = (isPortrait! ? (screenWidth ?? 360) : (screenHeight ?? 640)) / designWidth;
    blocHeightMultiplier = (screenHeight ?? 640) / designHeight;
  }
}

extension ResponsivePixle on num {
  double get w => this * (SizeConfig.blocWidthMultiplier ?? 10.0);
  double get h => this * (SizeConfig.blocHeightMultiplier ?? 10.0);
  double get sp => this * (SizeConfig.blocTextMultiplier ?? 10.0);
}