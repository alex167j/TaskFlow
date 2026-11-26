import 'package:flutter/foundation.dart';

import '../data/task.dart';
import '../data/task_repository.dart';

/// Estados posibles del listado de tareas. La vista los representa uno a
/// uno, de modo que nunca tiene que deducir qué mostrar combinando
/// banderas (`isLoading`, `tasks.isEmpty`, `errorMessage`, etc.).
enum TaskListStatus {
  /// Antes de la primera consulta (mientras la app arranca).
  initial,

  /// Consulta en curso: la pantalla muestra el indicador de carga.
  loading,

  /// Consulta correcta con al menos una tarea.
  success,

  /// Consulta correcta sin tareas: estado vacío.
  empty,

  /// La consulta falló: mensaje de error y opción de reintentar.
  error,
}

/// Convierte los datos del Repository en estado de interfaz.
/// No dibuja widgets: la vista decide cómo mostrar carga, lista,
/// vacío o error.
class TasksViewModel extends ChangeNotifier {
  TasksViewModel(this._repository);

  final TaskRepository _repository;

  TaskListStatus _status = TaskListStatus.initial;
  List<Task> _tasks = const [];
  String? _errorMessage;

  TaskListStatus get status => _status;

  bool get isLoading => _status == TaskListStatus.loading;

  List<Task> get tasks => List.unmodifiable(_tasks);

  String? get errorMessage => _errorMessage;

  bool get hasError => _status == TaskListStatus.error;

  int get pendingCount => _tasks.where((task) => !task.isCompleted).length;

  /// Siguiente id disponible para una tarea creada localmente. La API
  /// asignará el definitivo cuando exista la operación POST (sesión 10).
  int get nextTaskId =>
      _tasks.fold<int>(0, (maxId, task) => task.id > maxId ? task.id : maxId) +
      1;

  /// Agrega una tarea creada desde el formulario. Por ahora vive solo en
  /// memoria: la sesión 10 la enviará a la API con POST.
  void addTask(Task task) {
    _tasks = [..._tasks, task];
    _status = TaskListStatus.success;
    _errorMessage = null;
    notifyListeners();
  }

  Task? taskById(int id) {
    final matches = _tasks.where((task) => task.id == id);
    return matches.isEmpty ? null : matches.first;
  }

  /// Carga las tareas desde el Repository y publica cada transición:
  /// carga → éxito, vacío o error. También es la acción de **Reintentar**
  /// y de la actualización manual.
  Future<void> loadTasks() async {
    if (isLoading) return; // evita solicitudes duplicadas

    _status = TaskListStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final tasks = await _repository.getTasks();
      _tasks = tasks;
      _status = tasks.isEmpty ? TaskListStatus.empty : TaskListStatus.success;
    } catch (_) {
      // No exponemos detalles técnicos (URL, código HTTP, stack trace):
      // el usuario necesita saber qué ocurrió y qué puede hacer.
      _errorMessage = 'No se pudieron cargar las tareas. Revisa tu conexión e intenta de nuevo.';
      _status = TaskListStatus.error;
    }

    notifyListeners();
  }
}
