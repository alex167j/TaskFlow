import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/features/tasks/data/task.dart';

void main() {
  test('fromJson interpreta la respuesta de JSONPlaceholder', () {
    final task = Task.fromJson({
      'userId': 1,
      'id': 1,
      'title': 'delectus aut autem',
      'completed': false,
    });

    expect(task.id, 1);
    expect(task.title, 'delectus aut autem');
    expect(task.description, 'Sin descripción'); // la API no lo envía
    expect(task.priority, TaskPriority.medium); // valor por defecto
    expect(task.status, TaskStatus.pending); // completed: false
    expect(task.userId, 1);
  });

  test('fromJson interpreta el formato completo de la especificación', () {
    final task = Task.fromJson({
      'id': 12,
      'title': 'Entregar informe del taller',
      'description': 'Redactar el informe con los avances de la semana',
      'priority': 'high',
      'status': 'completed',
      'userId': 1,
    });

    expect(task.id, 12);
    expect(task.title, 'Entregar informe del taller');
    expect(
      task.description,
      'Redactar el informe con los avances de la semana',
    );
    expect(task.priority, TaskPriority.high);
    expect(task.status, TaskStatus.completed);
    expect(task.userId, 1);
  });

  test('fromJson tolera campos faltantes sin lanzar excepciones', () {
    final task = Task.fromJson(const {});

    expect(task.id, 0);
    expect(task.title, 'Sin título');
    expect(task.status, TaskStatus.pending);
    expect(task.priority, TaskPriority.medium);
  });
}
