class Tarea {
  final int id;
  final String nombreTarea;
  final String descripcion;
  final bool tareaCompletada;
  final DateTime fechaCreacion;
  final DateTime? tareaCompletadaFecha;

  Tarea({
    required this.id,
    required this.nombreTarea,
    required this.descripcion,
    required this.tareaCompletada,
    required this.fechaCreacion,
    this.tareaCompletadaFecha,
  });

  

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['id'],
      nombreTarea: json['nombre_tarea'],
      descripcion: json['descripcion'],
      tareaCompletada: json['tarea_completada'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      tareaCompletadaFecha: json['tarea_completada_fecha'] != null
          ? DateTime.parse(json['tarea_completada_fecha'])
          : null,
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_tarea': nombreTarea,
      'descripcion': descripcion,
      'tarea_completada': tareaCompletada,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'tarea_completada_fecha':
          tareaCompletadaFecha?.toIso8601String(),
    };
  }
}
