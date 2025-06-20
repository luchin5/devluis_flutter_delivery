import 'package:app2025_final/models/calificaciones_model.dart';
import 'package:app2025_final/models/estilo_model.dart';

class PromocionModel {
  int? id;
  String? nombre;
  String descripcion;
  List<String> fotos;
  double? valoracion;
  int? precio;
  int? precio_regular;
  int? totalclientecalificacion;
  int? descuento;
  EstiloModel estilo;
  int cantidad = 1;
  List<CalificacionesModel> calificaciones;
  // CONSTRUCTOR
  PromocionModel({
    required this.id,
    required this.nombre,
    required this.fotos,
    required this.descripcion,
    required this.valoracion,
    required this.precio,
    required this.totalclientecalificacion,
    required this.precio_regular,
    required this.calificaciones,
    required this.descuento,
    required this.estilo,
  });
  factory PromocionModel.fromJson(Map<String, dynamic> json) {
    return PromocionModel(
      id: json['id'],
      calificaciones:
          (json['calificaciones'] is List)
              ? (json['calificaciones'] as List)
                  .map((e) => CalificacionesModel.fromJson(e))
                  .toList()
              : [],
      descripcion: json['descripcion'],
      precio_regular: json['precio_regular'],
      totalclientecalificacion: json['total_cliente_calificacion'],
      nombre: json['nombre'],
      fotos: (json['foto'] is List) ? List<String>.from(json['foto']) : [],
      valoracion:
          json['valoracion'] != null
              ? (json['valoracion'] as num).toDouble()
              : null,
      precio: json['precio_normal'],
      descuento: json['descuento'],
      estilo: EstiloModel.fromJson(json['estilo']),
    );
  }
}
