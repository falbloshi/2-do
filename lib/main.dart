import 'package:two_do/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
          insetPadding: const EdgeInsets.all(16),
        ),
      ),
      title: "2 Do",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
