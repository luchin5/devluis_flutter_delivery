class UbicacionModel {
  int? id;
  String? departamento;
  String? provincia;
  String? distrito;
  String? direccion;
  double? latitud;
  double? longitud;
  int? cliente_id;
  int? zonatrabajo_id;
  String? etiqueta;
  String? numero_manzana;

  UbicacionModel(
      {this.id,
      this.provincia,
      this.departamento,
      this.distrito,
      this.direccion,
      this.latitud,
      this.longitud,
      this.cliente_id,
      this.zonatrabajo_id,
      this.numero_manzana,
      this.etiqueta});

  factory UbicacionModel.fromJson(Map<String, dynamic> json) {
    return UbicacionModel(
        id: json['id'],
        provincia: json['provincia'],
        departamento: json['departamento'],
        distrito: json['distrito'],
        direccion: json['direccion'],
        latitud: json['latitud'],
        longitud: json['longitud'],
        cliente_id: json['cliente_id'],
        zonatrabajo_id: json['zona_trabajo_id'],
        numero_manzana: json['numero_manzana'],
        etiqueta: json['etiqueta']);
  }
}
