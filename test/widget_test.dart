import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/main.dart';
import 'package:taskflow/widgets/task_card.dart';

void main() {
  testWidgets('El listado muestra el saludo y las tareas pendientes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());

    expect(find.text('TaskFlow'), findsOneWidget);
    expect(find.text('¡Hola, Alex GC!'), findsOneWidget);
    expect(find.textContaining('tareas pendientes'), findsOneWidget);
    expect(find.text('Entregar informe del taller'), findsOneWidget);
    expect(find.byType(TaskCard), findsWidgets);
  });

  testWidgets('Al tocar una tarjeta se abre la ruta de detalle', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());

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
    await tester.pumpWidget(const TaskFlowApp());

    // Abre una tarea distinta (id 2) para comprobar el parámetro de ruta.
    await tester.tap(find.text('Repasar layouts de Flutter'));
    await tester.pumpAndSettle();

    expect(find.text('Detalle de tarea'), findsOneWidget);
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
    await tester.pumpWidget(const TaskFlowApp());

    await tester.tap(find.text('Repasar layouts de Flutter'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('TaskFlow'), findsOneWidget);
    expect(
      find.text(
        'Estudiar Row, Column, Expanded y ListView antes de la sesión práctica con el docente.',
      ),
      findsOneWidget, // la tarjeta sigue en el listado: no se perdió nada
    );
  });
}
