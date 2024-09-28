import 'package:flutter/material.dart';
import 'package:task_id_week_04/core/routing/routes.dart';
import 'package:task_id_week_04/feature/home/presentation/screens/home_screen.dart';

class AppRoute {
  static MaterialPageRoute ongenerateroutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homescreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (builder) => Container());
    }
  }
}
