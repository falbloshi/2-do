import 'package:flutter/material.dart';
import 'package:two_do/pages/task_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TaskPage());
  }
}
