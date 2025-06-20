import 'dart:convert';

import 'package:app2025_final/models/cupon_model.dart';
import 'package:app2025_final/models/cuponcategoria_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CuponProvider extends ChangeNotifier {
  // ATRIBUTOS
  List<CuponCategoriaModel> _cuponCategoria = [];
  List<CuponCategoriaModel> get cuponesall => _cuponCategoria;
  String microUrl = dotenv.env['MICRO_URL'] ?? '';
  CuponModel? _cuponCargado;
  CuponModel? get cargarCupon => _cuponCargado;
  bool _cargado = false;
  bool get yacargo => _cargado;
  bool get estaCargado => _cuponCargado != null;

  // MÉTODOS
  Future<void> getallcupones() async {
    try {
      print("...dentro de cupones");
      var res = await http.get(Uri.parse("$microUrl/cupon"));
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        _cuponCategoria =
            (data as List).map((e) => CuponCategoriaModel.fromJson(e)).toList();
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print("Error de peticion $e");
    }
  }

  void setearCupon(CuponModel cupon) {
    _cuponCargado = cupon;
    notifyListeners();
  }

  void limpiarCupon() {
    _cuponCargado = null;
    _cargado = false;
    notifyListeners();
  }
}
