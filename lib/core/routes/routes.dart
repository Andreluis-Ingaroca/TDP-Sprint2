import 'package:flutter/material.dart';
import 'package:lexp/pages/home.dart';
import 'package:lexp/pages/login.dart';
import 'package:lexp/pages/onboarding.dart';
import 'package:lexp/pages/registro.dart';
import 'package:lexp/pages/today_task.dart';

class Routes {
  static const onBoarding = "/";
  static const home = "/home";
  static const todaysTask = "/task/todays";
  static const login = "/login";
  static const register = "/register";
}

class RouterGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoarding:
        return MaterialPageRoute(
          builder: ((context) => const OnboardingScreen()),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: ((context) => const HomeScreen()),
        );
      case Routes.todaysTask:
        return MaterialPageRoute(
          builder: ((context) => const TodaysTaskScreen()),
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: ((context) => const LoginScreen()),
        );
      case Routes.register:
        return MaterialPageRoute(
          builder: ((context) => const RegisterScreen()),
        );
      default:
        return MaterialPageRoute(
          builder: ((context) => const OnboardingScreen()),
        );
    }
  }
}
