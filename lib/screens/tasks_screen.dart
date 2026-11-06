import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/task.dart';
import '../widgets/task_card.dart';

const studentName = 'Alex GC';

/// Listado principal. contiene las 5 tareas de prueba de la Semana 2;
/// en la Semana 4 serán reemplazadas por la información de la API.
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  static const List<Task> tasks = [
    Task(
      id: 1,
      title: 'Entregar informe del taller',
      description: 'Redactar el informe del taller de Flutter con los avances de la Semana 1 y entregarlo en el aula virtual.',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
    ),
    Task(
      id: 2,
      title: 'Repasar layouts de Flutter',
      description: 'Estudiar Row, Column, Expanded y ListView antes de la sesión práctica con el docente.',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
    ),
    Task(
      id: 3,
      title: 'Resolver tabla CRUD',
      description: 'Investigar cómo quedaría el ciclo crear, editar y eliminar de una API de tareas de práctica.',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
    ),
    Task(
      id: 4,
      title: 'Practicar tarjetas en inglés',
      description: 'Repasar el vocabulario del nivel intermedio con 10 palabras nuevas por día.',
      priority: TaskPriority.low,
      status: TaskStatus.completed,
    ),
    Task(
      id: 5,
      title: 'Preparar quiz de inglés',
      description: 'Completar los ejercicios del módulo 3 y enviar el audio de pronunciación antes del viernes.',
      priority: TaskPriority.medium,
      status: TaskStatus.completed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pendingCount =
        tasks.where((task) => !task.isCompleted).length;

    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola, $studentName!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Tienes $pendingCount tareas pendientes.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(
                  task: task,
                  // Solo comunica la intención: abrir tarea <id>.
                  onTap: () => context.push('/task/${task.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
