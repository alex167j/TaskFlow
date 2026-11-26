import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/main.dart';
import 'package:taskflow/features/tasks/data/task.dart';
import 'package:taskflow/features/tasks/data/task_repository.dart';
import 'package:taskflow/features/tasks/presentation/widgets/task_card.dart';

void main() {
  testWidgets('El listado muestra el saludo y las tareas pendientes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const TaskFlowApp(repository: LocalTaskRepository()),
    );
    await tester.pumpAndSettle(); // espera la carga del ViewModel

    expect(find.text('TaskFlow'), findsOneWidget);
    expect(find.text('¡Hola, Alex GC!'), findsOneWidget);
    expect(find.textContaining('tareas pendientes'), findsOneWidget);
    expect(find.text('Entregar informe del taller'), findsOneWidget);
    expect(find.byType(TaskCard), findsWidgets);
  });

  testWidgets('Al tocar una tarjeta se abre la ruta de detalle', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const TaskFlowApp(repository: LocalTaskRepository()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Entregar informe del taller'));
    await tester.pumpAndSettle();

    expect(find.text('Detalle de tarea'), findsOneWidget);
    expect(
      find.text(
        'Redactar el informe del taller de Flutter con los avances de la Semana 1 y entregarlo en el aula virtual.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('El detalle se abre por id de la tarea tocada', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const TaskFlowApp(repository: LocalTaskRepository()),
    );
    await tester.pumpAndSettle();

    // Abre una tarea distinta (id 2) para comprobar el parámetro de ruta.
    await tester.tap(find.text('Repasar layouts de Flutter'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Estudiar Row, Column, Expanded y ListView antes de la sesión práctica con el docente.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Al regresar el listado se conserva completo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const TaskFlowApp(repository: LocalTaskRepository()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Repasar layouts de Flutter'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('TaskFlow'), findsOneWidget);
    expect(
      find.text(
        'Estudiar Row, Column, Expanded y ListView antes de la sesión práctica con el docente.',
      ),
      findsOneWidget, // la tarjeta sigue en el listado: no se perdió nada
    );
  });

  testWidgets('El error muestra Reintentar y recupera el listado', (
    WidgetTester tester,
  ) async {
    final repository = _FallibleTaskRepository();
    await tester.pumpWidget(TaskFlowApp(repository: repository));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('No se pudieron cargar las tareas'),
      findsOneWidget,
    );
    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.byType(TaskCard), findsNothing);

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(repository.calls, 2);
    expect(find.text('Tarea recuperada'), findsOneWidget);
    expect(find.text('Reintentar'), findsNothing);
  });

  testWidgets('El estado vacío se muestra cuando no hay tareas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const TaskFlowApp(repository: _EmptyTaskRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aún no tienes tareas registradas.'), findsOneWidget);
    expect(find.text('Actualizar'), findsOneWidget);
    expect(find.byType(TaskCard), findsNothing);
    expect(find.text('Tienes 0 tareas pendientes.'), findsOneWidget);
  });

  testWidgets('La barra superior ofrece actualizar manualmente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const TaskFlowApp(repository: LocalTaskRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Actualizar tareas'), findsOneWidget);
  });

  testWidgets('El botón flotante abre el formulario de nueva tarea', (
    WidgetTester tester,
  ) async {
    await _abrirFormulario(tester);

    expect(find.text('Nueva tarea'), findsOneWidget);
    expect(find.text('Título *'), findsOneWidget);
    expect(find.text('Prioridad *'), findsOneWidget);
    expect(find.text('Guardar tarea'), findsOneWidget);
  });

  testWidgets('El formulario valida y agrega la tarea al listado', (
    WidgetTester tester,
  ) async {
    await _abrirFormulario(tester);

    await tester.ensureVisible(find.text('Guardar tarea'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar tarea'));
    await tester.pumpAndSettle();

    expect(find.text('Escribe un título para la tarea.'), findsOneWidget);
    expect(find.text('Selecciona una prioridad.'), findsOneWidget);
    expect(find.text('Nueva tarea'), findsOneWidget); // sigue en el formulario

    await tester.enterText(
      find.byKey(const Key('task-title-field')),
      'Preparar la exposición',
    );
    await tester.tap(find.byKey(const Key('priority-high')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Guardar tarea'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar tarea'));
    await tester.pumpAndSettle();

    expect(find.text('Nueva tarea'), findsNothing);
    expect(find.text('Tienes 4 tareas pendientes.'), findsOneWidget);
    expect(find.text('Tarea agregada al listado.'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Preparar la exposición'), 200);
    expect(find.text('Preparar la exposición'), findsOneWidget);
  });

  testWidgets('La fecha límite es opcional y se puede quitar', (
    WidgetTester tester,
  ) async {
    await _abrirFormulario(tester);

    expect(find.text('Sin fecha'), findsOneWidget);

    await tester.ensureVisible(find.text('Sin fecha'));
    await tester.tap(find.text('Sin fecha'));
    await tester.pumpAndSettle();

    expect(find.text('Selecciona la fecha límite'), findsOneWidget);
    await tester.tap(find.text('Aceptar'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Quitar fecha'), findsOneWidget);
    expect(find.text('Sin fecha'), findsNothing);

    await tester.tap(find.byTooltip('Quitar fecha'));
    await tester.pumpAndSettle();

    expect(find.text('Sin fecha'), findsOneWidget);
    expect(find.byTooltip('Quitar fecha'), findsNothing);
  });
}

/// Abre el formulario desde el listado con datos locales.
Future<void> _abrirFormulario(WidgetTester tester) async {
  await tester.pumpWidget(const TaskFlowApp(repository: LocalTaskRepository()));
  await tester.pumpAndSettle();

  await tester.tap(find.byTooltip('Nueva tarea'));
  await tester.pumpAndSettle();
}

/// Falla la primera consulta y responde bien en el reintento.
class _FallibleTaskRepository implements TaskRepository {
  int calls = 0;

  @override
  Future<List<Task>> getTasks() async {
    calls++;
    if (calls == 1) {
      throw Exception('Fallo de red simulado');
    }
    return const [
      Task(
        id: 10,
        title: 'Tarea recuperada',
        description: 'La segunda consulta respondió correctamente.',
        priority: TaskPriority.medium,
        status: TaskStatus.pending,
        userId: 1,
      ),
    ];
  }
}

/// Consulta correcta sin tareas: permite comprobar el estado vacío.
class _EmptyTaskRepository implements TaskRepository {
  const _EmptyTaskRepository();

  @override
  Future<List<Task>> getTasks() async => const [];
}
