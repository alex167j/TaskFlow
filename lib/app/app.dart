import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../features/tasks/data/task_repository.dart';
import '../features/tasks/presentation/task_detail_screen.dart';
import '../features/tasks/presentation/tasks_screen.dart';
import '../features/tasks/presentation/tasks_view_model.dart';

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

/// Raíz de la aplicación: entrega Repository y ViewModel sin crear
/// dependencias globales, y configura el tema y las rutas.
class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TaskRepository>(
          create: (_) => LocalTaskRepository(),
        ),
        ChangeNotifierProvider<TasksViewModel>(
          create: (context) => TasksViewModel(
            context.read<TaskRepository>(),
          )..loadTasks(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'TaskFlow',
        theme: AppTheme.light,
        routerConfig: crearRouterDeApp(),
      ),
    );
  }
}
