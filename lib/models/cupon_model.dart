import 'package:app2025_final/models/productocupon_model.dart';

class CuponModel {
  int id;
  String? titulo;
  String? cupon_nombre;
  String foto;
  DateTime fecha_inicio;
  DateTime fecha_fin;
  String? regla_descuento;
  int? porcentaje;
  List<ProductoCuponModel> productos;

  CuponModel({
    required this.id,
    required this.titulo,
    required this.cupon_nombre,
    required this.foto,
    required this.fecha_inicio,
    required this.fecha_fin,
    required this.regla_descuento,
    required this.porcentaje,
    required this.productos,
  });

  factory CuponModel.fromJson(Map<String, dynamic> json) {
    return CuponModel(
      id: json['id_cupon'],
      titulo: json['titulo'],
      cupon_nombre: json['cupon_nombre'],
      fecha_inicio: DateTime.parse(json['fecha_inicio']),
      fecha_fin: DateTime.parse(json['fecha_fin']),
      foto: json['imagen'],
      regla_descuento: json['regla_descuento'],
      porcentaje: json['descuento'],
      productos:
          (json['producto'] != null)
              ? List<ProductoCuponModel>.from(
                json['producto'].map(
                  (item) => ProductoCuponModel.fromJson(item),
                ),
              )
              : [],
    );
  }
}
