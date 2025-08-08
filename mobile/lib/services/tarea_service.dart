import 'dart:convert';
import "package:http/http.dart" as http;
import '../models/tarea_model.dart';
import 'package:flutter/foundation.dart';

class TareaService {
  final String _url = 'https://gestion-de-tareas-eg5t.onrender.com/tareas';

  /// Obtener lista de tareas
  Future<List<Tarea>> obtenerTareas() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Tarea.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error ${response.statusCode}: No se pudieron cargar las tareas.',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión al cargar tareas: $e');
    }
  }

  //buscar tarea
  Future<List<Tarea>> buscarTareaPorNombre(String nombre) async {
    try {
      final response = await http.get(Uri.parse('$_url/buscar/$nombre'));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          // Convertimos cada elemento a Map<String, dynamic>
          return decoded
              .map((json) => Tarea.fromJson(Map<String, dynamic>.from(json)))
              .toList();
        } else if (decoded is Map) {
          // Convertimos el objeto a Map<String, dynamic> y lo metemos en lista
          return [Tarea.fromJson(Map<String, dynamic>.from(decoded))];
        } else {
          throw Exception('Formato de respuesta no esperado');
        }
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Error al buscar tarea: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al cargar tareas: $e');
    }
  }

  /// Crear una nueva tarea
  Future<String> crearTarea(Tarea tarea) async {
    if (tarea.nombreTarea.trim().isEmpty) {
      return 'El nombre de la tarea es obligatorio.';
    }

    if (tarea.descripcion.trim().isEmpty) {
      return 'La descripción de la tarea es obligatoria.';
    }

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tarea.toJson()),
      );

      if (response.statusCode == 201) {
        return 'Tarea creada exitosamente';
      } else {
        return 'Error al crear la tarea: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error de conexion al crear la tarea: $e';
    }
  }

  //actualizar tarea

  Future<bool> actualizarTarea(Tarea tarea) async {
    final url = Uri.parse('$_url/${tarea.id}');

    final body = jsonEncode({
      'nombre_tarea': tarea.nombreTarea,
      'descripcion': tarea.descripcion,
      'tarea_completada': tarea.tareaCompletada,
    });

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        debugPrint("La tarea ha sido actualizada correctamente");

        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error al actualizar la tarea");
      return false;
    }
  }

  Future<bool> eliminarTarea(Tarea tarea) async {
    final url = Uri.parse('$_url/${tarea.id}');

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint(' Tarea eliminada exitosamente');
        return true;
      } else {
        debugPrint(' Error al eliminar la tarea: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint(' Error de conexión al eliminar tarea: $e');
      return false;
    }
  }

  Future<bool> marcarTareaComoCompletada(int id) async {
    final url = Uri.parse('$_url/$id/completar');

    try {
      final response = await http.patch(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint(
          'Error al marcar tarea como completada: ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Excepción al marcar tarea como completada: $e');
      return false;
    }
  }
}
