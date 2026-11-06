/// Información del dominio que representa una tarea de la app.
/// En la Semana 2 alimenta el listado estático; en la Semana 4 se
/// mapeará desde el JSON de la API.
enum TaskPriority { high, medium, low }

enum TaskStatus { pending, completed }

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
  });

  final int id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;

  String get priorityName => switch (priority) {
        TaskPriority.high => 'Alta',
        TaskPriority.medium => 'Media',
        TaskPriority.low => 'Baja',
      };

  bool get isCompleted => status == TaskStatus.completed;
}
