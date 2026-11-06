import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/task_detail_screen.dart';
import 'screens/tasks_screen.dart';

/// Navegación declarativa de TaskFlow:
///   /          → listado de tareas
///   /task/:id  → detalle de una tarea, identificada por id
/// Cada instancia de la app crea su propio router para no compartir
/// estado de navegación entre ejecuciones (importante en pruebas).
GoRouter crearRouterDeApp() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: '/task/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? -1;
          return TaskDetailScreen(taskId: id);
        },
      ),
    ],
  );
}

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        // Paleta propia de TaskFlow (verde azulado).
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF256D85)),
        useMaterial3: true,
      ),
      routerConfig: crearRouterDeApp(),
    );
  }
}
