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
  int? _lastStatusCode;

  bool get isLoading => _isLoading;

  List<Task> get tasks => List.unmodifiable(_tasks);

  String? get errorMessage => _errorMessage;

  /// Código HTTP de la última consulta. Se muestra de forma temporal en
  /// la sesión 7 para comprobar la respuesta del servidor.
  int? get lastStatusCode => _lastStatusCode;

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
      final result = await _repository.getTasks();
      _tasks = result.tasks;
      _lastStatusCode = result.statusCode;
    } catch (_) {
      _errorMessage = 'No se pudieron cargar las tareas. Intenta de nuevo.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
