/// Información del dominio que representa una tarea de la app.
/// Vive en la capa de datos de la funcionalidad tasks y también se
/// construye desde el JSON de la API (Semana 4).
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
    this.dueDate,
  });

  final int id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final int userId;

  /// Fecha límite opcional (sesión 9). Puede faltar en la API.
  final DateTime? dueDate;

  String get priorityName => switch (priority) {
    TaskPriority.high => 'Alta',
    TaskPriority.medium => 'Media',
    TaskPriority.low => 'Baja',
  };

  bool get isCompleted => status == TaskStatus.completed;

  /// Convierte un mapa JSON de la API en un objeto Task tipado.
  /// Tolera el formato completo del mock versionado (con descripción,
  /// prioridad y estado) y respuestas reducidas tipo JSONPlaceholder
  /// (userId, id, title, completed).
  factory Task.fromJson(Map<String, dynamic> json) {
    final dueDate = json['dueDate'];

    return Task(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Sin título',
      description: json['description'] as String? ?? 'Sin descripción',
      priority: switch (json['priority']) {
        'high' => TaskPriority.high,
        'low' => TaskPriority.low,
        'medium' => TaskPriority.medium,
        _ => TaskPriority.medium,
      },
      status: switch (json['status']) {
        'completed' => TaskStatus.completed,
        'pending' => TaskStatus.pending,
        _ =>
          json['completed'] == true ? TaskStatus.completed : TaskStatus.pending,
      },
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      dueDate: dueDate is String ? DateTime.tryParse(dueDate) : null,
    );
  }
}
