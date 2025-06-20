class CategoriaModel {
  // Atributos
  int id;
  String nombre;
  String icono;

// Constructor
  CategoriaModel({required this.id, required this.nombre, required this.icono});

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
        id: json['id'], nombre: json['nombre'], icono: json['icono']);
  }
}
