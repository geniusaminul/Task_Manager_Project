import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: lightThemeData(),
    );
  }

  ThemeData lightThemeData() {
    return ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
            fillColor: Colors.white,
            filled: true,
            hintStyle: TextStyle(color: Colors.black38),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            )),
        textTheme: const TextTheme(
            titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: AppColors.headingColor,
        ),
          titleSmall: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2
          )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            fixedSize: const Size.fromWidth(double.maxFinite),
            backgroundColor: AppColors.themeColor,
            foregroundColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ));
  }
}
