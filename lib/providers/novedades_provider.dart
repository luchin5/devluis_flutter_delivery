import 'dart:convert';
import 'package:app2025_final/models/novedades_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NovedadesProvider extends ChangeNotifier {
  // ATRIBUTOS
  List<NovedadesModel>? _novedades = [];
  List<NovedadesModel>? get allnovedades => _novedades;
  String microUrl = dotenv.env['MICRO_URL'] ?? '';

  // MÉTODOS
  Future<void> getNovedades() async {
    try {
      print("...Consiguiendo novedades");
      var res = await http.get(Uri.parse("$microUrl/novedad"));
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        if (data is List) {
          _novedades =
              data.map((item) => NovedadesModel.fromJson(item)).toList();
        }
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print("Error en la petición: $e");
    }
  }
}
