import 'package:flutter/material.dart';
import 'package:lexp/models/time_qtty.dart';

class AppConstants {
  // Files and folders
  static const String _assets = "assets";
  static const String _svg = "$_assets/svg";
  static const String onBoardingSvg = "$_svg/onboarding.svg";
  static const String logoSvg = "$_svg/logo.svg";

  //Labels here
  static const String onBoarding = "LXP";
  static const String onBoardingSub1 =
      "Lorem ipsum dolor sit amet, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.";
  static const String onBoardingSub2 = "Lorem ipsum dolor 2";
  static const String onBoardingSub3 = "Lorem ipsum dolor sit amet, 3";

  //Maps
  static const Map<int, String> estadoAyuda = {
    1: "En proceso",
    2: "Completado",
  };

  static const Map<int, String> categoriaAyuda = {
    1: "Sistema",
    2: "Cuenta",
    3: "Otros",
  };

  //Objects here
  static final List<TimeQtty> timeQttyList = [
    TimeQtty(5, "0 - 5 min"),
    TimeQtty(10, "5 - 10 min"),
    TimeQtty(15, "10 - 15 min"),
    TimeQtty(20, "15 - 20 min"),
  ];

  static Widget get space => const SizedBox(height: 10);
  static Widget get spacew => const SizedBox(width: 10);

  //default values
  static const int timeout = 42;
  static const int defaultStatus = 1;
}
