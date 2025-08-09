import 'package:flutter/material.dart';
import '../../models/tarea_model.dart';
import '../../utils/dialog.dart';
import '../../utils/fecha_formateada.dart';

class ListaTareasWidget extends StatelessWidget {
  final List<Tarea> tareas;
  final Function(Tarea) onEditar;
  final Function(Tarea) onEliminar;
  final Function(Tarea) onToggleCompletada;
 // muestra una lista de tareas dividida en pendientes y completadas
  const ListaTareasWidget({
    super.key,
    required this.tareas,
    required this.onEditar,
    required this.onEliminar,
    required this.onToggleCompletada,
  });


  @override
  Widget build(BuildContext context) {
    final pendientes =
        tareas.where((t) => t.tareaCompletada == false).toList();
    final completadas =
        tareas.where((t) => t.tareaCompletada == true).toList();

    return ListView(
      children: [
        _buildSeccion(context, 'Pendientes', pendientes, false),
        _buildSeccion(context, 'Completadas', completadas, true),
      ],
    );
  }

// Construye una sección de la lista con un título y una lista de tareas
  Widget _buildSeccion(
      BuildContext context, String titulo, List<Tarea> lista, bool completadas) {
    if (lista.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "No hay tareas $titulo".toLowerCase(),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
// Si la lista está vacía, muestra un mensaje
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            titulo,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: completadas ? Colors.greenAccent : Colors.orangeAccent,
            ),
          ),
        ),
        ...lista.map((t) => _buildItem(context, t)),
      ],
    );
  }
 // Construye un item de la lista con los detalles de la tarea
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
            decoration: tarea.tareaCompletada
                ? TextDecoration.lineThrough
                : null,
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

        // Agrega botones de acción para editar y eliminar la tarea
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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