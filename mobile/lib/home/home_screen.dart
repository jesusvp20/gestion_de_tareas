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
  final TareaService _tareaService = TareaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<List<Tarea>>(
        future: _tareaService.obtenerTareas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final tareas = snapshot.data ?? [];

          if (tareas.isEmpty) {
            return const Center(child: Text("No hay tareas disponibles."));
          }

          return ListView.builder(
            itemCount: tareas.length,
            itemBuilder: (context, index) {
              final tarea = tareas[index];
              return ListTile(
                title: Text(tarea.nombreTarea),
                subtitle: Text(tarea.descripcion),
                trailing: Icon(
                  tarea.tareaCompletada ? Icons.check_circle : Icons.circle_outlined,
                  color: tarea.tareaCompletada ? Colors.green : Colors.grey,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
