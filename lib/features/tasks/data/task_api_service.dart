import 'package:dio/dio.dart';

import 'task.dart';

/// Resultado crudo de una consulta de tareas: los modelos ya convertidos
/// y el código HTTP recibido (útil como evidencia temporal de la sesión 7).
typedef FetchTasksResponse = ({List<Task> tasks, int statusCode});

/// Aísla los detalles técnicos de la red: URL base, método HTTP,
/// timeouts y conversión de la respuesta a modelos [Task].
class TaskApiService {
  TaskApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://jsonplaceholder.typicode.com',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  final Dio _dio;

  /// GET /todos?userId=1 y convierte la lista JSON en objetos Task.
  Future<FetchTasksResponse> fetchTasks({int userId = 1}) async {
    final response = await _dio.get<List<dynamic>>(
      '/todos',
      queryParameters: {'userId': userId},
    );

    final items = response.data ?? const <dynamic>[];
    final tasks = items
        .whereType<Map<String, dynamic>>()
        .map(Task.fromJson)
        .toList();

    return (tasks: tasks, statusCode: response.statusCode ?? 0);
  }
}
