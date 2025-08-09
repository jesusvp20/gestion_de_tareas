import 'package:flutter/material.dart';
import '../../models/tarea_model.dart';
import '../../services/tarea_service.dart';
import '../widgets/tarea_list_widgets.dart';
import '../widgets/tarea_form_widget.dart';
import '../widgets/barra_busqueda.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TareaService _tareaService = TareaService();
  List<Tarea> _todasLasTareas = [];
  List<Tarea> _tareasFiltradas = [];
  bool _mostrarBarraBusqueda = true;
  bool _hayBusquedaActiva = false;

// Inicializa el estado y carga las tareas al iniciar la pantalla.
  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }
 //cargamos las tareas desde el servicio y actualizamos el estado
  Future<void> _cargarTareas() async {
    final tareas = await _tareaService.obtenerTareas();
    setState(() {
      _todasLasTareas = tareas;
      _tareasFiltradas = tareas;
      _hayBusquedaActiva = false;
    });
  }
  
  void _mostrarMensaje(String mensaje, {Color color = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: color),
    );
  }
 // Abre el formulario para agregar o editar una tarea.
  void _abrirFormulario([Tarea? tarea]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      builder: (ctx) => TaskFormModal(
        tareaService: _tareaService,
        tarea: tarea,
        onGuardado: _cargarTareas,
        onMostrarMensaje: _mostrarMensaje,
      ),
    );
  }

//eliminamos una tarea y mostramos un mensaje de confirmación o error
  Future<void> _eliminarTarea(Tarea tarea) async {
    final eliminado = await _tareaService.eliminarTarea(tarea);
    if (eliminado) {
      _mostrarMensaje('Tarea eliminada', color: Colors.red);
      _cargarTareas();
    } else {
      _mostrarMensaje('Error al eliminar', color: Colors.red);
    }
  }
  
// Alterna el estado de completada de una tarea y actualiza la lista
  Future<void> _toggleCompletada(Tarea tarea) async {
    final nuevoEstado = !tarea.tareaCompletada;
    final resultado =
        await _tareaService.marcarTareaComoCompletada(tarea.id!, nuevoEstado);
    if (resultado) {
      _mostrarMensaje('Estado actualizado', color: Colors.blue);
      _cargarTareas();
    } else {
      _mostrarMensaje('Error al actualizar', color: Colors.red);
    }
  }
// Maneja la búsqueda de tareas y actualiza el estado con los resultados
  void _manejarBusqueda(List<Tarea> tareasBuscadas) {
    setState(() {
      _tareasFiltradas = tareasBuscadas;
      _hayBusquedaActiva = true;
    });
  }

// Carga todas las tareas y desactiva la búsqueda
  void _cargarTodasLasTareas() {
    setState(() {
      _tareasFiltradas = _todasLasTareas;
      _hayBusquedaActiva = false;
    });
  }

  @override
  // Construimos la interfaz de usuario de la pantalla principal
  Widget build(BuildContext context) {
    final tareasParaMostrar =
        _hayBusquedaActiva ? _tareasFiltradas : _todasLasTareas;

    final pendientes = tareasParaMostrar.where((t) => !t.tareaCompletada).toList();
    final completadas = tareasParaMostrar.where((t) => t.tareaCompletada).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.grey[900],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Pendientes"),
              Tab(text: "Completadas"),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                _mostrarBarraBusqueda ? Icons.keyboard_arrow_up : Icons.search,
                color: Colors.greenAccent,
              ),
              tooltip: _mostrarBarraBusqueda ? 'Ocultar búsqueda' : 'Mostrar búsqueda',
              onPressed: () {
                setState(() => _mostrarBarraBusqueda = !_mostrarBarraBusqueda);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            if (_mostrarBarraBusqueda)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BarraBusquedaWidget(
                  tareaService: _tareaService,
                  onBuscarTareas: _manejarBusqueda,
                  onCargarTodasTareas: _cargarTodasLasTareas,
                  onMostrarMensaje: _mostrarMensaje,
                ),
              ),
            Expanded(
              child: TabBarView(
                children: [
                  ListaTareasWidget(
                    tareas: pendientes,
                    titulo: 'Pendientes',
                    onEditar: _abrirFormulario,
                    onEliminar: _eliminarTarea,
                    onToggleCompletada: _toggleCompletada,
                  ),
                  ListaTareasWidget(
                    tareas: completadas,
                    titulo: 'Completadas',
                    onEditar: _abrirFormulario,
                    onEliminar: _eliminarTarea,
                    onToggleCompletada: _toggleCompletada,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
          onPressed: () => _abrirFormulario(),
        ),
      ),
    );
  }
}
