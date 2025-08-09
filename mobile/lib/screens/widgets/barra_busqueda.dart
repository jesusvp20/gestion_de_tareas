import 'package:flutter/material.dart';
import '../../services/tarea_service.dart';
import '../../models/tarea_model.dart';

class BarraBusquedaWidget extends StatefulWidget {
  final TareaService tareaService;
  final Function(List<Tarea>) onBuscarTareas;
  final VoidCallback onCargarTodasTareas;
  final Function(String, {Color color}) onMostrarMensaje;

  const BarraBusquedaWidget({
    super.key,
    required this.tareaService,
    required this.onBuscarTareas,
    required this.onCargarTodasTareas,
    required this.onMostrarMensaje,
  });

  @override
  State<BarraBusquedaWidget> createState() => _BarraBusquedaWidgetState();
}

class _BarraBusquedaWidgetState extends State<BarraBusquedaWidget> {
  final TextEditingController _controller = TextEditingController();
  //metodo para buscar tareas por nombre
  void _buscar() async {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      widget.onMostrarMensaje('Ingresa un nombre para buscar', color: Colors.orange);
      return;
    }
    try {
      final tareas = await widget.tareaService.buscarTareaPorNombre(query);
      widget.onBuscarTareas(tareas);
      if (tareas.isEmpty) {
        widget.onMostrarMensaje('Tarea no encontrada', color: Colors.red);
      }
    } catch (e) {
      widget.onMostrarMensaje('Error al buscar: $e', color: Colors.red);
    }
  }

// Construye la barra de búsqueda con un campo de texto y botones
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar tarea...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[900],
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _buscar(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.greenAccent),
            tooltip: 'Buscar',
            onPressed: _buscar,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blueAccent),
            tooltip: 'Recargar lista',
            onPressed: widget.onCargarTodasTareas,
          ),
        ],
      ),
    );
  }
}
