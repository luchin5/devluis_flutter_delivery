import 'dart:convert';

import 'package:app2025_final/models/categoria_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CategoriaProvider extends ChangeNotifier {
  // ATRIBUTO
  String microurl = dotenv.env['MICRO_URL'] ?? '';
  List<CategoriaModel> _categorias = [];

  // MÉTODOS
  List<CategoriaModel> get allcategorias => _categorias;

  // MÉTODO - LLAMADA DE API
  Future<void> getCategorias() async {
    try {
      var res = await http.get(Uri.parse('$microurl/categoria'));
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        _categorias = List<CategoriaModel>.from(
          data.map((item) => CategoriaModel.fromJson(item)),
        );
        notifyListeners();
        print("object Categoria");
      }
    } catch (e) {
      throw Exception("Error de query $e");
    }
  }
}
