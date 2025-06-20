import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AtencionClienteProvider extends ChangeNotifier {
  String microUrl = dotenv.env['MICRO_URL'] ?? '';

  Future<void> enviarReclamo(
    String nombres,
    String apellidos,
    String dni,
    String fecha,
    String tipoReclamo,
    String descripcion,
  ) async {
    try {
      final url = Uri.parse("$microUrl/libro_reclamaciones");
      final body = jsonEncode({
        "nombres": nombres,
        "apellidos": apellidos,
        "dni": dni,
        "fecha": fecha,
        "tipo_reclamo": tipoReclamo,
        "descripcion": descripcion,
      });

      final res = await http.post(
        url,
        body: body,
        headers: {"Content-type": "application/json"},
      );

      if (res.statusCode == 201) {
        print("Reclamo enviado exitosamente");
      } else {
        print("Error al enviar reclamo: ${res.body}");
        print('Error del servidor: ${res.statusCode}');
      }
    } catch (e) {
      print("Error en la petición: $e");
      //throw Exception('Error de conexión: $e');
    }
  }

  Future<void> enviarSolicitudSoporte(
    int cliente_id,
    String asunto,
    String descripcion,
  ) async {
    try {
      final url = Uri.parse("$microUrl/soporte_tecnico");
      final body = jsonEncode({
        "cliente_id": cliente_id,
        "asunto": asunto,
        "descripcion": descripcion,
      });

      final res = await http.post(
        url,
        body: body,
        headers: {"Content-type": "application/json"},
      );

      if (res.statusCode == 201) {
        print("Solicitud de soporte enviada exitosamente");
      } else {
        print("Error al enviar solicitud: ${res.body}");
        // throw Exception('Error del servidor: ${res.statusCode}');
      }
    } catch (e) {
      print("Error en la petición: $e");
      //throw Exception('Error de conexión: $e');
    }
  }
}
