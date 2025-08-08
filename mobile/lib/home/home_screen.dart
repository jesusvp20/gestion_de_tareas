import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tarea_model.dart';
import '../services/tarea_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _buscarController = TextEditingController();

  final TareaService _tareaService = TareaService();
  List<Tarea> _tareas = [];
  int? _idTareaSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

 String formatearFecha(DateTime? fecha) {
  if (fecha == null) return '';
  return DateFormat('dd/MM/yyyy hh:mm a').format(fecha);
}

  Future<void> _cargarTareas() async {
    try {
      final tareas = await _tareaService.obtenerTareas();
      setState(() {
        _tareas = tareas;
      });
    } catch (e) {
      _mostrarMensaje('Error al cargar tareas: $e');
    }
  }

  Future<void> _guardarTarea() async {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text.trim();
      final descripcion = _descripcionController.text.trim();

      try {
        if (_idTareaSeleccionada != null) {
          final tarea = Tarea(
            id: _idTareaSeleccionada!,
            nombreTarea: nombre,
            descripcion: descripcion,
            tareaCompletada: false,
          );
          await _tareaService.actualizarTarea(tarea);
          _mostrarMensaje('Tarea actualizada correctamente');
        } else {
          final tarea = Tarea(
            nombreTarea: nombre,
            descripcion: descripcion,
            tareaCompletada: false,
          );
          await _tareaService.crearTarea(tarea);
          _mostrarMensaje('Tarea creada correctamente');
        }

        _limpiarCampos();
        await _cargarTareas();
      } catch (e) {
        _mostrarMensaje('Error al guardar tarea: $e');
      }
    }
  }

  Future<void> _eliminarTarea(Tarea tarea) async {
    try {
      final confirmacion = await _mostrarDialogoConfirmacion();
      if (confirmacion == true) {
        final resultado = await _tareaService.eliminarTarea(tarea);
        if (resultado) {
          setState(() {
            _tareas.removeWhere((t) => t.id == tarea.id);
          });
          _mostrarMensaje('Tarea eliminada');
        } else {
          _mostrarMensaje('No se pudo eliminar la tarea');
        }
      }
    } catch (e) {
      _mostrarMensaje('Error al eliminar tarea: $e');
    }
  }

  Future<void> _buscarTareaPorNombre() async {
    final nombre = _buscarController.text.trim();
    if (nombre.isEmpty) {
      _cargarTareas();
      return;
    }

    try {
      final resultado = await _tareaService.buscarTareaPorNombre(nombre);
      setState(() {
        _tareas = resultado;
      });
    } catch (e) {
      _mostrarMensaje('Error al buscar: $e');
    }
  }

  void _seleccionarTarea(Tarea tarea) {
    setState(() {
      _idTareaSeleccionada = tarea.id;
      _nombreController.text = tarea.nombreTarea;
      _descripcionController.text = tarea.descripcion;
    });
  }

  void _limpiarCampos() {
    setState(() {
      _idTareaSeleccionada = null;
      _nombreController.clear();
      _descripcionController.clear();
    });
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _marcarTareaComoCompletada(Tarea tarea) async {
    try {
      final resultado = await _tareaService.marcarTareaComoCompletada(tarea.id!);
      if (resultado) {
        _mostrarMensaje('Tarea marcada como completada');
        _cargarTareas();
      } else {
        _mostrarMensaje('Error al marcar tarea como completada');
      }
    } catch (e) {
      _mostrarMensaje('Error: $e');
    }
  }

  Future<bool?> _mostrarDialogoConfirmacion() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo de búsqueda
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _buscarController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar por nombre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _buscarTareaPorNombre,
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Formulario
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) => value!.isEmpty ? 'Ingrese un nombre' : null,
                  ),
                  TextFormField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) => value!.isEmpty ? 'Ingrese una descripción' : null,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _guardarTarea,
                        child: Text(
                          _idTareaSeleccionada == null ? 'Crear' : 'Actualizar',
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (_idTareaSeleccionada != null)
                        ElevatedButton(
                          onPressed: _limpiarCampos,
                          child: const Text('Cancelar'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lista de tareas
            Expanded(
              child: ListView.builder(
                itemCount: _tareas.length,
                itemBuilder: (context, index) {
                  final tarea = _tareas[index];
                  return Card(
                    child: ListTile(
                      title: Text(tarea.nombreTarea),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tarea.descripcion),
                          if (tarea.fechaCreacion != null)
                            Text(
                              'Creada: ${formatearFecha(tarea.fechaCreacion)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.blueGrey,
                              ),
                            ),
                          if (tarea.fechaCompletado != null)
                            Text(
                              'Completada: ${formatearFecha(tarea.fechaCompletado)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: tarea.tareaCompletada,
                            onChanged: (bool? valor) {
                              if (valor == true && !tarea.tareaCompletada) {
                                _marcarTareaComoCompletada(tarea);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _eliminarTarea(tarea),
                          ),
                        ],
                      ),
                      onTap: () => _seleccionarTarea(tarea),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
