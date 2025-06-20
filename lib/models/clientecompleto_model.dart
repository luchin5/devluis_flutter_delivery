import 'package:app2025_final/models/cliente_model.dart';
import 'package:app2025_final/models/usuario_model.dart';

class ClienteCompletoModel {
  final UserModel user;
  final ClienteModel cliente;

  ClienteCompletoModel({required this.user, required this.cliente});

  factory ClienteCompletoModel.fromJson(Map<String, dynamic> json) {
    return ClienteCompletoModel(
      user: UserModel.fromJson(json['user']),
      cliente: ClienteModel.fromJson(json['cliente']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'cliente': cliente.toJson()};
  }
}
