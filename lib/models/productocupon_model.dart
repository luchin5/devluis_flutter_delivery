class ProductoCuponModel {
  int id;
  String? nombre;
  String? descripcion;
  List<String> foto;
  double valoracion;
  String? tipo_empaque;
  int? cantidad;
  String? unidadmedida;
  double volumen_unidad;

  ProductoCuponModel(
      {required this.id,
      required this.nombre,
      required this.descripcion,
      required this.foto,
      required this.valoracion,
      required this.tipo_empaque,
      required this.cantidad,
      required this.unidadmedida,
      required this.volumen_unidad});

  factory ProductoCuponModel.fromJson(Map<String, dynamic> json) {
    return ProductoCuponModel(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      foto: List<String>.from(json['foto']),
      valoracion: (json['valoracion'] as num).toDouble(),
      tipo_empaque: json['tipo_empaque'],
      cantidad: json['cantidad_unidad'],
      unidadmedida: json['unidad_medida'],
      volumen_unidad: (json['volumen_unidad'] as num).toDouble(),
    );
  }
}
