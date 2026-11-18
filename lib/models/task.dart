/// Información del dominio que representa una tarea de la app.
/// En la Semana 2 alimenta el listado estático; más adelante se
/// mapeará desde el JSON de la API (sesión 7).
enum TaskPriority { high, medium, low }

enum TaskStatus { pending, completed }

/// Modelo principal de TaskFlow: representa una tarea del dominio,
/// no un elemento de interfaz.
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.userId,
  });

  final int id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final int userId;

  String get priorityName => switch (priority) {
        TaskPriority.high => 'Alta',
        TaskPriority.medium => 'Media',
        TaskPriority.low => 'Baja',
      };

  bool get isCompleted => status == TaskStatus.completed;
}
