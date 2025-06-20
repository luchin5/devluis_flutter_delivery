class TemperaturaModel {
  String ciudad;
  String mensaje;
  String temperatura;

  // CONSTRUCTOR
  TemperaturaModel(
      {required this.ciudad, required this.temperatura, required this.mensaje});
  factory TemperaturaModel.fromJson(Map<String, dynamic> json) {
    return TemperaturaModel(
        ciudad: json['ciudad'],
        mensaje: json['mensaje'],
        temperatura: json['temperatura']);
  }
}
