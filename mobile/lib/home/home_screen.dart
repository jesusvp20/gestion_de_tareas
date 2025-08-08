import 'package:flutter/material.dart';
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
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final busquedaController = TextEditingController();

  bool tareaCompletada = false;
  Tarea? tareaEditando;
  List<Tarea> tareas = [];

  final TareaService tareaService = TareaService();

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    busquedaController.dispose();
    super.dispose();
  }

  Future<void> _cargarTareas() async {
    try {
      final lista = await tareaService.obtenerTareas();
      setState(() {
        tareas = lista;
      });
    } catch (e) {
      _mostrarError('Error al cargar tareas: $e');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _mostrarFormulario({Tarea? tarea}) {
    setState(() {
      tareaEditando = tarea;
      nombreController.text = tarea?.nombreTarea ?? '';
      descripcionController.text = tarea?.descripcion ?? '';
      tareaCompletada = tarea?.tareaCompletada ?? false;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tarea == null ? 'Crear Tarea' : 'Editar Tarea',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la tarea',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'El nombre es obligatorio' : null,
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'La descripción es obligatoria' : null,
                ),
                SwitchListTile(
                  title: const Text('¿Tarea completada?', style: TextStyle(color: Colors.white)),
                  value: tareaCompletada,
                  onChanged: (value) {
                    setState(() {
                      tareaCompletada = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _guardarTarea,
                  child: Text(tarea == null ? 'Crear' : 'Actualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      _formKey.currentState?.reset();
      nombreController.clear();
      descripcionController.clear();
      tareaCompletada = false;
      tareaEditando = null;
    });
  }

  Future<void> _guardarTarea() async {
    if (!_formKey.currentState!.validate()) return;

    final nuevaTarea = Tarea(
      id: tareaEditando?.id,
      nombreTarea: nombreController.text.trim(),
      descripcion: descripcionController.text.trim(),
      tareaCompletada: tareaCompletada,
      fechaCreacion: tareaEditando?.fechaCreacion ?? DateTime.now(),
    );

    try {
      bool exito;
      if (tareaEditando == null) {
        final mensaje = await tareaService.crearTarea(nuevaTarea);
        exito = mensaje == 'Tarea creada exitosamente';
      } else {
        exito = await tareaService.actualizarTarea(nuevaTarea);
      }

      if (exito) {
        await _cargarTareas();
        if (!mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tareaEditando == null ? 'Tarea creada' : 'Tarea actualizada')),
        );
      } else {
        _mostrarError('No se pudo guardar la tarea');
      }
    } catch (e) {
      _mostrarError('Error: $e');
    }
  }

  Future<void> _eliminarTarea(Tarea tarea) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eliminar tarea'),
      content: Text('¿Estás seguro de eliminar la tarea "${tarea.nombreTarea}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );

  if (confirmado != true) return;

  try {
    final exito = await tareaService.eliminarTarea(tarea);

    if (!mounted) return; 

    if (exito) {
      await _cargarTareas();

      if (!mounted) return; 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarea eliminada')),
      );
    } else {
      _mostrarError('No se pudo eliminar la tarea');
    }
  } catch (e) {
    _mostrarError('Error al eliminar tarea: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: const Color(0xFF1B263B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: busquedaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Buscar tarea por ID',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final input = busquedaController.text.trim();
                    if (input.isEmpty) return _mostrarError('Ingresa un ID válido');

                    final id = int.tryParse(input);
                    if (id == null) return _mostrarError('ID inválido');

                    try {
                      final tareasEncontradas  = await tareaService.buscarTarea(id);
                      setState(() {
                        tareas = tareasEncontradas;
                      });
                    } catch (e) {
                      _mostrarError('No se encontró la tarea con ID $id');
                    }
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                ),
                IconButton(
                  onPressed: () {
                    busquedaController.clear();
                    _cargarTareas();
                  },
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Restablecer lista',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tareas.isEmpty
                  ? const Center(child: Text('No hay tareas registradas.', style: TextStyle(color: Colors.white70)))
                  : ListView.builder(
                      itemCount: tareas.length,
                      itemBuilder: (context, index) {
                        final tarea = tareas[index];
                        return Card(
                          color: const Color(0xFF1B263B),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              tarea.nombreTarea,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(tarea.descripcion, style: const TextStyle(color: Colors.white70)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(
                                        tarea.tareaCompletada ? 'Completada' : 'Pendiente',
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      backgroundColor: tarea.tareaCompletada ? Colors.green[200] : Colors.orange[200],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Creado: ${tarea.fechaCreacion.toString().substring(0, 16)}',
                                      style: const TextStyle(fontSize: 12, color: Colors.white60),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            leading: Icon(
                              tarea.tareaCompletada ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: tarea.tareaCompletada ? Colors.greenAccent : Colors.grey[400],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white),
                                  onPressed: () => _mostrarFormulario(tarea: tarea),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _eliminarTarea(tarea),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarFormulario,
        label: const Text("Agregar"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
