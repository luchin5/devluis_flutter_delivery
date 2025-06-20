import 'package:app2025_final/models/producto_model.dart';
import 'package:app2025_final/models/promocion_model.dart';

class SubcategoriaModel {
  int? id;
  String? nombre;
  String? icono;
  String fecha_inicio;
  String fecha_fin;
  List<ProductoModel> productos;
  List<PromocionModel> promociones;
  // CONSTRUCTOR
  SubcategoriaModel({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.fecha_inicio,
    required this.fecha_fin,
    required this.productos,
    required this.promociones,
  });

  factory SubcategoriaModel.fromJson(Map<String, dynamic> json) {
    return SubcategoriaModel(
      id: json['id'],
      nombre: json['nombre'],
      icono: json['icono'],
      fecha_inicio: json['fecha_inicio'],
      fecha_fin: json['fecha_fin'],
      productos:
          (json['productos'] != null)
              ? List<ProductoModel>.from(
                json['productos'].map((item) => ProductoModel.fromJson(item)),
              )
              : [],
      promociones:
          (json['promociones'] != null)
              ? List<PromocionModel>.from(
                json['promociones'].map(
                  (item) => PromocionModel.fromJson(item),
                ),
              )
              : [],
    );
  }
}
