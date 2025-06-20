import 'dart:convert';

import 'package:app2025_final/models/subcategoria_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SubcategoriaProvider extends ChangeNotifier {
  // ATRIBUTOS
  SubcategoriaModel? _subcategoria;
  SubcategoriaModel? get allproductossubcategoria => _subcategoria;
  String microurl = dotenv.env['MICRO_URL'] ?? '';

  // MÉTODO DE SUBCATEGORIA ESPECIFICA SUB_ID, ZONA_ID
  Future<void> getSubcategoria(int id, int? zonatrabajoCliente) async {
    try {
      print(".....SUBCTEGORIA ESPECIFICA zona:$zonatrabajoCliente");
      // 1 => sub / 1 => ubicacion
      print('$microurl/all_subcategoria_productos/${id}/${zonatrabajoCliente}');
      var res = await http.get(
        Uri.parse(
          '$microurl/all_subcategoria_productos/${id}/${zonatrabajoCliente}',
        ),
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        _subcategoria = SubcategoriaModel.fromJson(data);

        print("dentro del subcategoria provider");
        print("${_subcategoria?.nombre}");
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print("$e");
    }
  }
}
