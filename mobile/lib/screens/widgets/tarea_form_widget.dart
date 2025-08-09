import 'package:flutter/material.dart';
import '../../models/tarea_model.dart';
import '../../services/tarea_service.dart';

class TaskFormModal extends StatefulWidget {
  final TareaService tareaService;
  final Tarea? tarea;
  final VoidCallback onGuardado;
  final Function(String, {Color color}) onMostrarMensaje;

  const TaskFormModal({
    super.key,
    required this.tareaService,
    this.tarea,
    required this.onGuardado,
    required this.onMostrarMensaje,
  });

  @override
  State<TaskFormModal> createState() => _TaskFormModalState();
}

class _TaskFormModalState extends State<TaskFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;

// Inicializa los controladores de texto con los valores de la tarea si existen.

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.tarea?.nombreTarea ?? '',
    );
    _descripcionController = TextEditingController(
      text: widget.tarea?.descripcion ?? '',
    );
  }
 //metodo para guardar la tarea, ya sea nueva o editada
  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final tarea = Tarea(
        id: widget.tarea?.id,
        nombreTarea: _nombreController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        tareaCompletada: widget.tarea == null ? false : false,
        fechaCreacion: widget.tarea?.fechaCreacion ?? DateTime.now(),
        fechaCompletado: null,
    );
   //si es una tarea nueva, la creamos, si no, la actualizamos
    if (widget.tarea == null) {

      final mensaje = await widget.tareaService.crearTarea(tarea);
      
      widget.onMostrarMensaje( mensaje, color: mensaje.contains('exitosamente') ? Colors.green : Colors.red, );
    } else {
      final actualizado = await widget.tareaService.actualizarTarea(tarea);
      if (actualizado) {
        widget.onMostrarMensaje('Tarea actualizada', color: Colors.blue);
      } else {
        widget.onMostrarMensaje('Error al actualizar', color: Colors.red);
      }
    }

  // Llama al callback para actualizar la lista de tareas en la pantalla principal
    widget.onGuardado();

    if (!mounted) return;

    Navigator.pop(context);
  }

// Limpia los controladores de texto al cerrar el modal
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey[900],
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.tarea == null ? "Nueva Tarea" : "Editar Tarea",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nombreController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingrese un nombre' : null,
              ),
              // Espacio entre los campos de texto
              const SizedBox(height: 8),
              TextFormField(
                controller: _descripcionController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Ingrese una descripción'
                    : null,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                icon: const Icon(Icons.save),
                label: const Text("Guardar"),
                onPressed: _guardar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  