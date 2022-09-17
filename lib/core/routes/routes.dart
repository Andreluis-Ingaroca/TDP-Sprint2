import 'package:flutter/material.dart';
import 'package:lexp/pages/actions_my_categories.dart';
import 'package:lexp/pages/add_my_category.dart';
import 'package:lexp/pages/delete_my_category.dart';
import 'package:lexp/pages/delete_my_course.dart';
import 'package:lexp/pages/home.dart';
import 'package:lexp/pages/login.dart';
import 'package:lexp/pages/onboarding.dart';
import 'package:lexp/pages/page.dart';
import 'package:lexp/pages/preferences.dart';
import 'package:lexp/pages/register.dart';
import 'package:lexp/pages/today_task.dart';

import '../../pages/actions_my_courses.dart';
import '../../pages/add_my_course.dart';
import '../../pages/administrator.dart';

class Routes {
  static const onBoarding = "/";
  static const home = "/home";
  static const todaysTask = "/task/todays";
  static const login = "/login";
  static const register = "/register";
  static const preferences = "/preferences";
  static const page = "/page";
  static const administrator = "/administrator";
  static const actionsMyCategories = "/actionsMyCategories";
  static const addMyCategory = "/addMyCategory";
  static const deleteMyCategory = "/deleteMyCategory";
  static const actionsMyCourses = "/actionsMyCourses";
  static const addMyCourse = "/addMyCourse";
  static const deleteMyCourse = "/deleteMyCourse";
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
      case Routes.preferences:
        return MaterialPageRoute(
          builder: ((context) => const PreferencesScreen()),
        );
      case Routes.page:
        return MaterialPageRoute(
          builder: ((context) => const PageScreen()),
        );
      case Routes.administrator:
        return MaterialPageRoute(
          builder: ((context) => const AdministratorScreen()),
        );
      case Routes.actionsMyCategories:
        return MaterialPageRoute(
          builder: ((context) => const ActionsMyCategoriesScreen()),
        );
      case Routes.addMyCategory:
        return MaterialPageRoute(
          builder: ((context) => const AddMyCategoryScreen()),
        );
      case Routes.deleteMyCategory:
        return MaterialPageRoute(
          builder: ((context) => const DeleteMyCategoryScreen()),
        );
      case Routes.actionsMyCourses:
        return MaterialPageRoute(
          builder: ((context) => const ActionsMyCoursesScreen()),
        );
      case Routes.addMyCourse:
        return MaterialPageRoute(
          builder: ((context) => const AddMyCourseScreen()),
        );
      case Routes.deleteMyCourse:
        return MaterialPageRoute(
          builder: ((context) => const DeleteMyCourseScreen()),
        );
      default:
        return MaterialPageRoute(
          builder: ((context) => const OnboardingScreen()),
        );
    }
  }
}
