class ClienteModel {
  int? id;
  String? nombres;
  String? apellidos;
  String? fotoCliente;

  ClienteModel({
    this.id,
    this.nombres,
    this.apellidos,
    this.fotoCliente,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      fotoCliente: json['foto_cliente'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'foto_cliente': fotoCliente,
    };
  }
}
