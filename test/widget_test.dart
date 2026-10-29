import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/main.dart';

void main() {
  testWidgets('La pantalla de bienvenida muestra el saludo y las tareas pendientes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());

    expect(find.text('TaskFlow'), findsOneWidget);
    expect(find.textContaining('Tareas pendientes'), findsOneWidget);
    expect(find.textContaining('¡Hola,'), findsOneWidget);
    expect(find.text('Tareas pendientes: 3'), findsOneWidget);
  });

  testWidgets('Agregar tarea incrementa el contador de tareas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());

    await tester.tap(find.text('Agregar tarea'));
    await tester.pump();

    expect(find.text('Tareas pendientes: 4'), findsOneWidget);
  });

  testWidgets('Completar tarea disminuye pendientes y aumenta completadas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());

    await tester.tap(find.text('Completar tarea'));
    await tester.pump();

    expect(find.text('Tareas pendientes: 2'), findsOneWidget);
    expect(find.text('Tareas completadas: 1'), findsOneWidget);
  });

  testWidgets('No se pueden completar tareas cuando no hay pendientes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Completar tarea'));
      await tester.pump();
    }
    expect(find.text('Tareas pendientes: 0'), findsOneWidget);

    // Con el botón deshabilitado, un toque extra no cambia el estado.
    await tester.tap(find.text('Completar tarea'), warnIfMissed: false);
    await tester.pump();

    expect(find.text('Tareas completadas: 3'), findsOneWidget);
  });
}
