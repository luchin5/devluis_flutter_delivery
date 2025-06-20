import 'package:app2025_final/models/calificaciones_model.dart';
import 'package:app2025_final/models/estilo_model.dart';

class ProductoModel {
  int? id;
  String? nombre;
  List<String> fotos;
  double? valoracion;
  int? precio; // normal
  int? precio_regular;
  int? descuento;
  String tipo_empaque;
  String descripcion;
  EstiloModel estilo;
  int? totalclientecalificacion;
  String unidad_medidad;
  int? cantidad_unidad;
  int cantidad = 1;
  int? volumen_unidad;
  List<CalificacionesModel> calificaciones;

  //CONSTRUCTOR
  ProductoModel({
    required this.id,
    required this.descripcion,
    required this.tipo_empaque,
    required this.nombre,
    required this.fotos,
    required this.precio_regular,
    required this.unidad_medidad,
    required this.totalclientecalificacion,
    required this.valoracion,
    required this.precio,
    required this.cantidad_unidad,
    required this.volumen_unidad,
    required this.descuento,
    required this.calificaciones,
    required this.estilo,
  });
  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'],
      totalclientecalificacion: json['total_cliente_calificacion'],
      precio_regular: json['precio_regular'],
      unidad_medidad: json['unidad_medida'],
      nombre: json['nombre'],
      volumen_unidad: json['volumen_unidad'],
      cantidad_unidad: json['cantidad_unidad'],
      calificaciones:
          (json['calificaciones'] is List)
              ? (json['calificaciones'] as List)
                  .map((e) => CalificacionesModel.fromJson(e))
                  .toList()
              : [],
      fotos: (json['foto'] is List) ? List<String>.from(json['foto']) : [],
      valoracion:
          json['valoracion'] != null
              ? (json['valoracion'] as num).toDouble()
              : null,
      precio: json['precio_normal'],
      descripcion: json['descripcion'],
      tipo_empaque: json['tipo_empaque'],
      descuento: json['descuento'],
      estilo: EstiloModel.fromJson(json['estilo']),
    );
  }
}
