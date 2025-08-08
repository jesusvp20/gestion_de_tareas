import 'dart:convert';
import "package:http/http.dart" as http;
import '../models/tarea_model.dart';

class TareaService {
  final String _url = 'https://gestion-de-tareas-eg5t.onrender.com/tareas';

  Future<List<Tarea>> obtenerTareas() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Tarea.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar las tareas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
}
