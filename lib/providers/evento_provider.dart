import 'dart:convert';
import 'package:app2025_final/models/evento_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EventoProvider extends ChangeNotifier {
  String microurl = dotenv.env['MICRO_URL'] ?? '';
  List<EventobannerModel> _eventos = [];
  List<EventobannerModel> get todoseventos => _eventos;

  Future<void> getEventos() async {
    try {
      var res = await http.get(Uri.parse('$microurl/publicidad'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        _eventos =
            (data as List).map((e) => EventobannerModel.fromJson(e)).toList();

        notifyListeners(); // Notifica a los widgets que usan este provider
      } else {
        throw Exception("Error de servidor: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de query $e");
    }
  }
}

// COMPLETO
