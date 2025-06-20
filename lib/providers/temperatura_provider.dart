import 'dart:convert';

import 'package:app2025_final/models/temperatura_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TemperaturaProvider extends ChangeNotifier {
  //ATRIBUTOS
  TemperaturaModel? _temperatura;
  TemperaturaModel? get temptoday => _temperatura;
  String microUrl = dotenv.env['MICRO_URL'] ?? '';
  //MÉTODOS
  Future<void> getTemperatura() async {
    try {
      print("...dentro de temeparautra ");
      var res = await http.get(
        Uri.parse('$microUrl/temperatura?city=Arequipa'),
      );
      if (res.statusCode == 200) {
        print("entre");
        var data = jsonDecode(res.body);
        print("..........data temp");
        print(data);
        _temperatura = TemperaturaModel.fromJson(data);
        print("temperatura $_temperatura");
        notifyListeners();
      }
    } catch (e) {
      print("$e");
    }
  }
}
