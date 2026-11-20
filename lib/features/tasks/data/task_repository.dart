import 'task.dart';
import 'task_api_service.dart';

/// Resultado de una consulta de tareas: los modelos y, cuando existe,
/// el código HTTP de la respuesta (evidencia temporal de la sesión 7).
class TasksResult {
  const TasksResult({required this.tasks, this.statusCode});

  final List<Task> tasks;
  final int? statusCode;
}

/// Contrato de acceso a datos de tareas.
///
/// La interfaz es la única que conoce el ViewModel: así se puede cambiar
/// entre una fuente local y una API REST sin tocar la interfaz de usuario.
abstract class TaskRepository {
  /// Devuelve todas las tareas disponibles.
  Future<TasksResult> getTasks();
}

/// Implementación real: solicita las tareas a la API mediante el
/// TaskApiService y entrega modelos listos para la app.
class TaskApiRepository implements TaskRepository {
  TaskApiRepository(this._apiService);

  final TaskApiService _apiService;

  @override
  Future<TasksResult> getTasks() async {
    final response = await _apiService.fetchTasks();
    return TasksResult(tasks: response.tasks, statusCode: response.statusCode);
  }
}

/// Implementación local de respaldo: datos de prueba de las sesiones 3 y 4.
/// Se usa en pruebas automatizadas y como fuente temporal sin red.
class LocalTaskRepository implements TaskRepository {
  const LocalTaskRepository();

  static const List<Task> _tasks = [
    Task(
      id: 1,
      title: 'Entregar informe del taller',
      description: 'Redactar el informe del taller de Flutter con los avances de la Semana 1 y entregarlo en el aula virtual.',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      userId: 1,
    ),
    Task(
      id: 2,
      title: 'Repasar layouts de Flutter',
      description: 'Estudiar Row, Column, Expanded y ListView antes de la sesión práctica con el docente.',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      userId: 1,
    ),
    Task(
      id: 3,
      title: 'Resolver tabla CRUD',
      description: 'Investigar cómo quedaría el ciclo crear, editar y eliminar de una API de tareas de práctica.',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      userId: 1,
    ),
    Task(
      id: 4,
      title: 'Practicar tarjetas en inglés',
      description: 'Repasar el vocabulario del nivel intermedio con 10 palabras nuevas por día.',
      priority: TaskPriority.low,
      status: TaskStatus.completed,
      userId: 1,
    ),
    Task(
      id: 5,
      title: 'Preparar quiz de inglés',
      description: 'Completar los ejercicios del módulo 3 y enviar el audio de pronunciación antes del viernes.',
      priority: TaskPriority.medium,
      status: TaskStatus.completed,
      userId: 1,
    ),
  ];

  @override
  Future<TasksResult> getTasks() async => const TasksResult(tasks: _tasks);
}
