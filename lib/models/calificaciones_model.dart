class CalificacionesModel {
  int id;
  String nombres;
  String apellidos;
  double? calificacion;

  CalificacionesModel(
      {required this.id,
      required this.nombres,
      required this.apellidos,
      required this.calificacion});

  factory CalificacionesModel.fromJson(Map<String, dynamic> json) {
    return CalificacionesModel(
      id: json['id'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      calificacion: json['calificacion'] != null
          ? (json['calificacion'] as num).toDouble()
          : null,
    );
  }
}
