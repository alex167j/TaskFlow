import 'dart:convert';

import 'package:dio/dio.dart';

import 'task.dart';

/// Aísla los detalles técnicos de la red: URL base, método HTTP,
/// timeouts y conversión de la respuesta a modelos [Task].
///
/// La URL base apunta a un JSON de práctica versionado en el repositorio
/// del proyecto (tareas en español, solo lectura). En la sesión 9–10 se
/// sustituirá por el servicio definitivo con escritura.
class TaskApiService {
  TaskApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl:
                  'https://raw.githubusercontent.com/alex167j/TaskFlow/main',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  final Dio _dio;

  /// GET /mock/tasks.json y convierte la lista JSON en objetos Task.
  /// GitHub sirve el archivo como texto plano, por eso se decodifica
  /// con [jsonDecode] en lugar de esperar el parseo automático de dio.
  ///
  /// Solo devuelve modelos: los estados de la interfaz (carga, vacío,
  /// error) son responsabilidad del ViewModel.
  Future<List<Task>> fetchTasks() async {
    final response = await _dio.get<String>(
      '/mock/tasks.json',
      options: Options(responseType: ResponseType.plain),
    );

    final decoded = jsonDecode(response.data ?? '[]');
    final items = decoded is List ? decoded : const <dynamic>[];
    final tasks = items
        .whereType<Map<String, dynamic>>()
        .map(Task.fromJson)
        .toList();

    return tasks;
  }
}
