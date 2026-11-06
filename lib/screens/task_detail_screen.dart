import 'package:flutter/material.dart';

import '../models/task.dart';

/// Detalle provisional de una tarea (sin go_router).
/// En la sesión 4 se reemplazará por una ruta con parámetro de id.
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor =
        task.isCompleted ? const Color(0xFF2E7D32) : colorScheme.primary;

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
              Icon(
                switch (task.priority) {
                  TaskPriority.high => Icons.local_fire_department,
                  TaskPriority.medium => Icons.remove_circle_outline,
                  TaskPriority.low => Icons.arrow_downward,
                },
                color: colorScheme.primary,
              ),
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
