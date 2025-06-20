//departamento_model.dart
class DepartamentoModel {
  final int id;
  final String nombre;

  DepartamentoModel({required this.id, required this.nombre});

  factory DepartamentoModel.fromJson(Map<String, dynamic> json) {
    return DepartamentoModel(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}

//distrito_model.dart
class DistritoModel {
  final int id;
  final String nombre;

  DistritoModel({required this.id, required this.nombre});

  factory DistritoModel.fromJson(Map<String, dynamic> json) {
    return DistritoModel(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}
