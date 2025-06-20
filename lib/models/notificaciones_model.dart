import 'package:intl/intl.dart';

class NotificacionesModel {
  int id;
  String foto;
  String titulo;
  DateTime fecha;

  String descripcion;

  NotificacionesModel(
      {required this.id,
      required this.foto,
      required this.titulo,
      required this.fecha,
      required this.descripcion});

  factory NotificacionesModel.fromJson(Map<String, dynamic> json) {
    final formatoFecha = DateFormat('yyyy/MM/dd');
    final fecha =
        formatoFecha.parse(json['fecha']); // <-- Esto arregla el error

    return NotificacionesModel(
      id: json['id'],
      foto: json['foto'],
      titulo: json['titulo'],
      fecha: fecha,
      descripcion: json['descripcion'],
    );
  }
}
