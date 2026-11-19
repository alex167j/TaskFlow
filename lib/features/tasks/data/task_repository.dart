import 'task.dart';

/// Contrato de acceso a datos de tareas.
///
/// La interfaz es la única que conoce el ViewModel: así mañana puede
/// cambiar de una fuente local a una API REST sin tocar la interfaz
/// de usuario.
abstract class TaskRepository {
  /// Devuelve todas las tareas disponibles.
  Future<List<Task>> getTasks();
}

/// Implementación temporal con los datos de prueba de las sesiones 3 y 4.
/// En la Semana 4 la sustituye una implementación conectada a la API,
/// sin modificar el ViewModel ni las pantallas.
class LocalTaskRepository implements TaskRepository {
  static const List<Task> _tasks = [
    Task(
      id: 1,
      title: 'Entregar informe del taller',
      description:
          'Redactar el informe del taller de Flutter con los avances de la Semana 1 y entregarlo en el aula virtual.',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      userId: 1,
    ),
    Task(
      id: 2,
      title: 'Repasar layouts de Flutter',
      description:
          'Estudiar Row, Column, Expanded y ListView antes de la sesión práctica con el docente.',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      userId: 1,
    ),
    Task(
      id: 3,
      title: 'Resolver tabla CRUD',
      description:
          'Investigar cómo quedaría el ciclo crear, editar y eliminar de una API de tareas de práctica.',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      userId: 1,
    ),
    Task(
      id: 4,
      title: 'Practicar tarjetas en inglés',
      description:
          'Repasar el vocabulario del nivel intermedio con 10 palabras nuevas por día.',
      priority: TaskPriority.low,
      status: TaskStatus.completed,
      userId: 1,
    ),
    Task(
      id: 5,
      title: 'Preparar quiz de inglés',
      description:
          'Completar los ejercicios del módulo 3 y enviar el audio de pronunciación antes del viernes.',
      priority: TaskPriority.medium,
      status: TaskStatus.completed,
      userId: 1,
    ),
  ];

  @override
  Future<List<Task>> getTasks() async => _tasks;
}
