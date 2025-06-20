import 'dart:convert';

import 'package:app2025_final/models/delivery_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DeliveryProvider extends ChangeNotifier {
  List<DeliveryModel>? _delivery = [];
  List<DeliveryModel>? get alldelivery => _delivery;
  String microUrl = dotenv.env['MICRO_URL'] ?? '';

  Future<void> getDeliverys() async {
    try {
      print("METODO DELIVERY");
      var res = await http.get(Uri.parse("$microUrl/delivery_pedidos"));
      if (res.statusCode == 200) {
        print("...dentro de dliev");
        var data = jsonDecode(res.body);
        _delivery =
            (data as List).map((e) => DeliveryModel.fromJson(e)).toList();

        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print("Error en la peticion $e");
    }
  }
}
