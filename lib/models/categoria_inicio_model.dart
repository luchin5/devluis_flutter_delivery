import 'package:app2025_final/models/subcategoria_model.dart';

class CategoriaSubcategoriaModel {
  int? id;
  String? nombre;
  int zona_trabajo;
  List<SubcategoriaModel> subcategorias;

  CategoriaSubcategoriaModel({
    required this.id,
    required this.nombre,
    required this.zona_trabajo,
    required this.subcategorias,
  });

  factory CategoriaSubcategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaSubcategoriaModel(
      id: json['id'],
      nombre: json['nombre'],
      zona_trabajo: json['zona_trabajo_id'],
      subcategorias:
          (json['subcategorias'] as List)
              .map((item) => SubcategoriaModel.fromJson(item))
              .toList(),
    );
  }
}
