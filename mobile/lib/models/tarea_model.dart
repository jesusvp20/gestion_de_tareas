class Tarea {
  final int? id;
  final String nombreTarea;
  final String descripcion;
  final bool tareaCompletada;
  final DateTime? fechaCreacion;

  Tarea({
    this.id,
    required this.nombreTarea,
    required this.descripcion,
    required this.tareaCompletada,
    this.fechaCreacion,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['id'],
      nombreTarea: json['nombre_tarea'],
      descripcion: json['descripcion'],
      tareaCompletada: json['tarea_completada'],
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre_tarea': nombreTarea,
      'descripcion': descripcion,
      'tarea_completada': tareaCompletada,
    };
  }
}
