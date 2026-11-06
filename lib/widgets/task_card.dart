import 'package:flutter/material.dart';

import '../models/task.dart';

/// Tarjeta reutilizable que representa una tarea en el listado.
/// Cada instancia muestra: título, descripción corta, prioridad,
/// estado y una acción para ver el detalle.
class TaskCard extends StatelessWidget {
  const TaskCard({required this.task, this.onTap, super.key});

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = task.isCompleted
        ? const Color(0xFF2E7D32)
        : colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          task.isCompleted ? Icons.task_alt : Icons.pending,
                          size: 14,
                          color: statusColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task.isCompleted ? 'Completada' : 'Pendiente',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    switch (task.priority) {
                      TaskPriority.high => Icons.local_fire_department,
                      TaskPriority.medium => Icons.remove_circle_outline,
                      TaskPriority.low => Icons.arrow_downward,
                    },
                    size: 16,
                    color: switch (task.priority) {
                      TaskPriority.high => Colors.red.shade700,
                      TaskPriority.medium => Colors.orange.shade800,
                      TaskPriority.low => Colors.green.shade700,
                    },
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Prioridad: ${task.priorityName}',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, size: 22),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
