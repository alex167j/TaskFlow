import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'tasks_view_model.dart';
import 'widgets/task_card.dart';

const studentName = 'Alex GC';

/// Listado principal. Solo presenta el estado que publica el
/// TasksViewModel y le envía intenciones de usuario.
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TasksViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola, $studentName!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Tienes ${viewModel.pendingCount} tareas pendientes.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                // Evidencia temporal de la sesión 7: código HTTP recibido.
                if (viewModel.lastStatusCode != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.cloud_done, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Respuesta HTTP: ${viewModel.lastStatusCode}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Expanded(child: TaskListView(viewModel: viewModel)),
        ],
      ),
    );
  }
}

/// Presenta carga, error o la lista según el estado del ViewModel.
class TaskListView extends StatelessWidget {
  const TaskListView({required this.viewModel, super.key});

  final TasksViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(viewModel.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: viewModel.loadTasks,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.tasks.isEmpty) {
      return const Center(child: Text('Aún no tienes tareas registradas.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: viewModel.tasks.length,
      itemBuilder: (context, index) {
        final task = viewModel.tasks[index];
        return TaskCard(
          task: task,
          // Solo comunica la intención: abrir tarea <id>.
          onTap: () => context.push('/task/${task.id}'),
        );
      },
    );
  }
}
