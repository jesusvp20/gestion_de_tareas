import 'package:flutter/material.dart';
import '../../models/tarea_model.dart';
import '../../utils/dialog.dart';
import '../../utils/fecha_formateada.dart';

class ListaTareasWidget extends StatelessWidget {
  final List<Tarea> tareas;
  final String titulo;
  final Function(Tarea) onEditar;
  final Function(Tarea) onEliminar;
  final Function(Tarea) onToggleCompletada;

  const ListaTareasWidget({
    super.key,
    required this.tareas,
    required this.titulo,
    required this.onEditar,
    required this.onEliminar,
    required this.onToggleCompletada,
  });

// Verifica si la sección es de tareas completadas
  bool get esCompletadas => titulo.toLowerCase() == "completadas";

  @override
  Widget build(BuildContext context) {
    if (tareas.isEmpty) {
      return Center(
        child: Text(
          "No hay tareas ${titulo.toLowerCase()}",
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
  // Construimos la lista de tareas con un título y una lista de elementos
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            titulo,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: esCompletadas ? Colors.greenAccent : Colors.orangeAccent,
            ),
          ),
        ),
        ...tareas.map((t) => _buildItem(context, t)),
      ],
    );
  }
 // Construye un elemento de la lista con información de la tarea
  Widget _buildItem(BuildContext context, Tarea tarea) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: tarea.tareaCompletada,
          activeColor: Colors.green,
          onChanged: (_) => onToggleCompletada(tarea),
        ),
        title: Text(
          tarea.nombreTarea,
          style: TextStyle(
            color: Colors.white,
            decoration:
                tarea.tareaCompletada ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Creado: ${FormatearFecha.formatearFecha(tarea.fechaCreacion)}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            if (tarea.tareaCompletada && tarea.fechaCompletado != null)
              Text(
                "Completado: ${FormatearFecha.formatearFecha(tarea.fechaCompletado)}",
                style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
              ),
          ],
        ),
        // Acciones para editar y eliminar la tarea
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!esCompletadas)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEditar(tarea),
              ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirmar =
                    await DialogUtils.mostrarDialogoConfirmacion(context);
                if (confirmar == true) {
                  onEliminar(tarea);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}