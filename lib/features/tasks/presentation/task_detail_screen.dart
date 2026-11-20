import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/task.dart';
import 'tasks_view_model.dart';

/// Detalle de una tarea, identificado únicamente por su id.
/// La información proviene del TasksViewModel (que a su vez la obtiene
/// del Repository), nunca de la pantalla de listado.
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({required this.taskId, super.key});

  final int taskId;

  @override
  Widget build(BuildContext context) {
    final task = context.watch<TasksViewModel>().taskById(taskId);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tarea no encontrada'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('No existe una tarea con ese identificador.'),
        ),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = task.isCompleted
        ? const Color(0xFF2E7D32)
        : colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                task.isCompleted ? Icons.task_alt : Icons.pending,
                color: statusColor,
              ),
              const SizedBox(width: 8),
              Text(task.isCompleted ? 'Completada' : 'Pendiente'),
              const Spacer(),
              Icon(switch (task.priority) {
                TaskPriority.high => Icons.local_fire_department,
                TaskPriority.medium => Icons.remove_circle_outline,
                TaskPriority.low => Icons.arrow_downward,
              }, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text('Prioridad: ${task.priorityName}'),
            ],
          ),
          const SizedBox(height: 24),
          Text('Descripción', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(task.description, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
