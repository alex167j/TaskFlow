import 'package:flutter/material.dart';

import 'screens/tasks_screen.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        // Paleta propia de TaskFlow (verde azulado).
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF256D85)),
        useMaterial3: true,
      ),
      home: const TasksScreen(),
    );
  }
}
