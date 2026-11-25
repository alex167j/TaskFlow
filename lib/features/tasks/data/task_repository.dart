import 'task.dart';
import 'task_api_service.dart';

/// Contrato de acceso a datos de tareas.
///
/// La interfaz es la única que conoce el ViewModel: así se puede cambiar
/// entre una fuente local y una API REST sin tocar la interfaz de usuario.
/// Devuelve datos o lanza una excepción; interpretar ambos casos como
/// estados de pantalla corresponde al ViewModel.
abstract class TaskRepository {
  /// Devuelve todas las tareas disponibles.
  Future<List<Task>> getTasks();
}

/// Implementación real: solicita las tareas a la API mediante el
/// TaskApiService y entrega modelos listos para la app.
class TaskApiRepository implements TaskRepository {
  TaskApiRepository(this._apiService);

  final TaskApiService _apiService;

  @override
  Future<List<Task>> getTasks() => _apiService.fetchTasks();
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
  Future<List<Task>> getTasks() async => _tasks;
}
