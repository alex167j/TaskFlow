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

  testWidgets('Al tocar una tarjeta se abre el detalle de la tarea', (
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

  testWidgets('La flecha de regreso vuelve al listado de tareas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());

    await tester.tap(find.text('Entregar informe del taller'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('TaskFlow'), findsOneWidget);
    expect(
      find.text('Redactar el informe del taller de Flutter con los avances de la Semana 1 y entregarlo en el aula virtual.'),
      findsOneWidget, // la tarjeta del listado sigue visible: no se pierde nada
    );
  });
}
