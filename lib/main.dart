import 'package:flutter/material.dart';
import 'package:task_id_week_04/core/routing/app_route.dart';
import 'package:task_id_week_04/feature/home/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        return AppRoute.ongenerateroutes(settings);
      },
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
