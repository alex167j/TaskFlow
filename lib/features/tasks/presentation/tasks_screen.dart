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
      appBar: AppBar(
        title: const Text('TaskFlow'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Actualizar tareas',
            onPressed: viewModel.isLoading ? null : viewModel.loadTasks,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
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
                  _resumen(viewModel),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(child: TaskListView(viewModel: viewModel)),
        ],
      ),
    );
  }

  /// Resume el estado actual sin repetir la lógica de la lista.
  String _resumen(TasksViewModel viewModel) => switch (viewModel.status) {
    TaskListStatus.initial ||
    TaskListStatus.loading => 'Consultando tus tareas…',
    TaskListStatus.error => 'No pudimos actualizar el listado.',
    TaskListStatus.empty => 'Tienes 0 tareas pendientes.',
    TaskListStatus.success =>
      'Tienes ${viewModel.pendingCount} tareas pendientes.',
  };
}

/// Presenta un widget distinto para cada estado del ViewModel.
/// La vista no hace HTTP: solo invoca `loadTasks` cuando el usuario
/// reintenta o actualiza.
class TaskListView extends StatelessWidget {
  const TaskListView({required this.viewModel, super.key});

  final TasksViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.status) {
      TaskListStatus.initial || TaskListStatus.loading => const _LoadingState(),
      TaskListStatus.error => _ErrorState(
        message:
            viewModel.errorMessage ??
            'No se pudieron cargar las tareas. Intenta de nuevo.',
        onRetry: viewModel.loadTasks,
      ),
      TaskListStatus.empty => _EmptyState(onRefresh: viewModel.loadTasks),
      TaskListStatus.success => RefreshIndicator(
        onRefresh: viewModel.loadTasks,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
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
        ),
      ),
    };
  }
}

/// Estado de carga: la consulta está en curso.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Cargando tareas…',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Estado de error: explica el problema y ofrece una acción recuperable.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Estado vacío: la consulta funcionó, pero no hay tareas. Se puede
/// actualizar deslizando hacia abajo o con el botón.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aún no tienes tareas registradas.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Cuando agregues una tarea aparecerá en este listado.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: onRefresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Actualizar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
