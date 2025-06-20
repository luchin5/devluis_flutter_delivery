class HistorialModel {
  int id;
  DateTime fecha;
  String estado;
  double total;
  List<String> fotos;
  String direccion;

  HistorialModel(
      {required this.id,
      required this.fecha,
      required this.estado,
      required this.total,
      required this.fotos,
      required this.direccion});

  factory HistorialModel.fromJson(Map<String, dynamic> json) {
    return HistorialModel(
      id: json['pedido_id'],
      fecha: DateTime.parse(json['fecha']),
      estado: json['estado'],
      direccion: json['direccion'],
      total: (json['total'] as num).toDouble(),
      fotos: (json['fotos'] is List) ? List<String>.from(json['fotos']) : [],
    );
  }
}
