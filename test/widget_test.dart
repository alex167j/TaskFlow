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
  });
}
