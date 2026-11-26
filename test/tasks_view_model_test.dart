import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/features/tasks/data/task.dart';
import 'package:taskflow/features/tasks/data/task_repository.dart';
import 'package:taskflow/features/tasks/presentation/tasks_view_model.dart';

/// Repository de prueba: entrega las respuestas en el orden indicado,
/// de modo que una misma prueba puede simular fallo y reintento.
class _FakeTaskRepository implements TaskRepository {
  _FakeTaskRepository(this._responses);

  final List<Future<List<Task>> Function()> _responses;
  int calls = 0;

  @override
  Future<List<Task>> getTasks() {
    final response = _responses[calls];
    calls++;
    return response();
  }
}

const _task = Task(
  id: 1,
  title: 'Preparar la exposición',
  description: 'Armar las diapositivas del proyecto integrador.',
  priority: TaskPriority.high,
  status: TaskStatus.pending,
  userId: 1,
);

void main() {
  test('publica carga y después éxito', () async {
    final completer = Completer<List<Task>>();
    final viewModel = TasksViewModel(
      _FakeTaskRepository([() => completer.future]),
    );

    final loading = viewModel.loadTasks();
    expect(viewModel.status, TaskListStatus.loading);
    expect(viewModel.isLoading, isTrue);

    completer.complete(const [_task]);
    await loading;

    expect(viewModel.status, TaskListStatus.success);
    expect(viewModel.isLoading, isFalse);
    expect(viewModel.tasks, hasLength(1));
    expect(viewModel.tasks.first.title, 'Preparar la exposición');
    expect(viewModel.errorMessage, isNull);
  });

  test('una respuesta sin datos produce el estado vacío', () async {
    final viewModel = TasksViewModel(
      _FakeTaskRepository([() async => const []]),
    );

    await viewModel.loadTasks();

    expect(viewModel.status, TaskListStatus.empty);
    expect(viewModel.tasks, isEmpty);
    expect(viewModel.hasError, isFalse);
  });

  test('un fallo produce error y el reintento recupera la lista', () async {
    final repository = _FakeTaskRepository([
      () async => throw Exception('sin conexión'),
      () async => const [_task],
    ]);
    final viewModel = TasksViewModel(repository);

    await viewModel.loadTasks();

    expect(viewModel.status, TaskListStatus.error);
    expect(viewModel.hasError, isTrue);
    expect(viewModel.errorMessage, isNotNull);
    expect(viewModel.tasks, isEmpty);

    await viewModel.loadTasks();

    expect(repository.calls, 2);
    expect(viewModel.status, TaskListStatus.success);
    expect(viewModel.errorMessage, isNull);
    expect(viewModel.tasks, hasLength(1));
  });

  test('no duplica la solicitud mientras hay una carga en curso', () async {
    final completer = Completer<List<Task>>();
    final repository = _FakeTaskRepository([() => completer.future]);
    final viewModel = TasksViewModel(repository);

    final first = viewModel.loadTasks();
    final second = viewModel.loadTasks(); // debe ignorarse
    await second;

    expect(repository.calls, 1);

    completer.complete(const [_task]);
    await first;

    expect(viewModel.status, TaskListStatus.success);
    expect(repository.calls, 1);
  });

  test('agrega una tarea local y calcula el siguiente id', () async {
    final viewModel = TasksViewModel(
      _FakeTaskRepository([() async => const []]),
    );
    await viewModel.loadTasks();

    expect(viewModel.status, TaskListStatus.empty);
    expect(viewModel.nextTaskId, 1);

    viewModel.addTask(_task);

    expect(viewModel.status, TaskListStatus.success);
    expect(viewModel.tasks, hasLength(1));
    expect(viewModel.tasks.first.title, 'Preparar la exposición');
    expect(viewModel.nextTaskId, 2);
    expect(viewModel.errorMessage, isNull);
  });
}
