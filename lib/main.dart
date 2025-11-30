import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:two_do/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('tasksBox');
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
