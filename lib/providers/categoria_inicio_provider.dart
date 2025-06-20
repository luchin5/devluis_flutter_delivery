import 'dart:convert';

import 'package:app2025_final/models/categoria_inicio_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CategoriaInicioProvider extends ChangeNotifier {
  String microurl = dotenv.env['MICRO_URL'] ?? '';

  // TRIPA COMPLETA
  CategoriaSubcategoriaModel? _categoriaCompleta;
  CategoriaSubcategoriaModel? get todolacategoriacompleta => _categoriaCompleta;

  // SOLO PARA HOME LIMITADO A 2
  CategoriaSubcategoriaModel? _categoriaSubcategoriaModel;

  CategoriaSubcategoriaModel? get allcategoria_subcategoria =>
      _categoriaSubcategoriaModel;

  // varibales para recuperar
  int? _categoriaIdSeleccionada;

  int? get categoriaIdSeleccionada => _categoriaIdSeleccionada;

  int? _zonaTrabajoId;

  int? get zonaTrabajoId => _zonaTrabajoId;

  void setCategoriaSeleccionada(int categoriaId) {
    _categoriaIdSeleccionada = categoriaId;
    notifyListeners();
  }

  void setZonaTrabajoId(int? id) {
    _zonaTrabajoId = id;
    notifyListeners();
  }

  Future<void> getCategoriaSubcategoria(int? id, int ubicacionClienteId) async {
    try {
      _categoriaSubcategoriaModel = null;
      notifyListeners();
      print("....SE CARGA EL HOME CON LA CATEGORIA ESCOGIDA");
      // SUBCATEGORÍA POR DEFECTO ARRANCA EN EL AGUA ->
      final categoriaId = id ?? 1;
      var res = await http.get(
        Uri.parse('$microurl/categoria/${categoriaId}/${ubicacionClienteId}'),
      ); // ESTE ENDPOINT LIMITA A 2 SUBCATEGORIAS EN EL HOME PARA NO ABRUMAR AL CLIENTE
      if (res.statusCode == 200) {
        //print("....CAT CAT ${res.body}");
        var data = jsonDecode(res.body);
        _categoriaSubcategoriaModel = CategoriaSubcategoriaModel.fromJson(data);
        // print("//////// -------- CAT --------- //////////");
        //print(data);
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      throw Exception("Error query $e");
    }
  }

  Future<void> getCategoriaCompleta(int categoriaId, int zonaTrabajoId) async {
    try {
      print("...dentro del toda la categoria tripa");
      print("ids recibidos ${categoriaId} $zonaTrabajoId");
      print(
        "$microurl/all_categorias_subcategoria/${categoriaId}/${zonaTrabajoId}",
      );
      var res = await http.get(
        Uri.parse(
          "$microurl/all_categorias_subcategoria/${categoriaId}/${zonaTrabajoId}",
        ),
      );

      /// ESTE ENDPOINT TRAE LA TRIPA COMPLETA

      if (res.statusCode == 200) {
        print("..llega la tripa");
        var data = jsonDecode(res.body);
        _categoriaCompleta = CategoriaSubcategoriaModel.fromJson(data);
        print("//////// -------- CAT --------- //////////");
        print(data);
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print("Error en la petición $e");
    }
  }

  void limpiarCategoriaSubModel() {
    _categoriaSubcategoriaModel = null;
  }

  void setCategoriaSubcategoria(CategoriaSubcategoriaModel model) {
    _categoriaSubcategoriaModel = model;
    notifyListeners();
  }
}
