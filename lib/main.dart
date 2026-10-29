import 'package:flutter/material.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        // Paleta propia de TaskFlow (verde azulado).
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF256D85)),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const studentName = 'Alex GC';
  static const courseName = 'Desarrollo de aplicaciones móviles';

  int pendingTasks = 3;
  int completedTasks = 0;
  int totalTasks = 3;

  void _addTask() {
    setState(() {
      pendingTasks++;
      totalTasks++;
    });
  }

  void _completeTask() {
    setState(() {
      pendingTasks--;
      completedTasks++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final canComplete = pendingTasks > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_outline, size: 56),
            const SizedBox(height: 24),
            Text(
              '¡Hola, $studentName!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text('Bienvenido/a a $courseName.'),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.pending_actions, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Text('Tareas pendientes: $pendingTasks'),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.task_alt, color: colorScheme.secondary),
                    const SizedBox(width: 12),
                    Text('Tareas completadas: $completedTasks'),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.list_alt, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Text('Tareas totales: $totalTasks'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _addTask,
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar tarea'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: canComplete ? _completeTask : null,
                    icon: const Icon(Icons.done),
                    label: const Text('Completar tarea'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
