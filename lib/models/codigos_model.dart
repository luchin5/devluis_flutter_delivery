class CodigoDescuentoModel {
  final int id;
  final String codigo;
  final double descuento;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  CodigoDescuentoModel({
    required this.id,
    required this.codigo,
    required this.descuento,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory CodigoDescuentoModel.fromJson(Map<String, dynamic> json) {
    return CodigoDescuentoModel(
      id: json['id'],
      codigo: json['codigo'],
      descuento: json['descuento'].toDouble(),
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      fechaFin: DateTime.parse(json['fecha_fin']),
    );
  }
}
