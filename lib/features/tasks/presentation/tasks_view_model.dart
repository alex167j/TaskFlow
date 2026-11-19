import 'package:flutter/foundation.dart';

import '../data/task.dart';
import '../data/task_repository.dart';

/// Convierte los datos del Repository en estado de interfaz.
/// No dibuja widgets: la vista decide cómo mostrar carga, lista o error.
class TasksViewModel extends ChangeNotifier {
  TasksViewModel(this._repository);

  final TaskRepository _repository;

  bool _isLoading = false;
  List<Task> _tasks = const [];
  String? _errorMessage;

  bool get isLoading => _isLoading;

  List<Task> get tasks => List.unmodifiable(_tasks);

  String? get errorMessage => _errorMessage;

  int get pendingCount => _tasks.where((task) => !task.isCompleted).length;

  Task? taskById(int id) {
    final matches = _tasks.where((task) => task.id == id);
    return matches.isEmpty ? null : matches.first;
  }

  /// Carga las tareas desde el Repository y notifica a la vista.
  Future<void> loadTasks() async {
    if (_isLoading) return; // evita solicitudes duplicadas
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _repository.getTasks();
    } catch (_) {
      _errorMessage =
          'No se pudieron cargar las tareas. Intenta de nuevo.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
