import 'dart:convert';

import 'package:app2025_final/models/distritos_model.dart';
import 'package:app2025_final/models/ubicacion_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UbicacionProvider extends ChangeNotifier {
  // ATRIBUTOS
  List<UbicacionModel> _ubicaciones = [];
  List<UbicacionModel> get allubicaciones => _ubicaciones;
  String microUrl = dotenv.env['MICRO_URL'] ?? '';
  UbicacionModel? _ubicacionTemp;
  UbicacionModel? get getUbicaiontemp => _ubicacionTemp;
  bool get isEditing => _ubicacionTemp?.id != null;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int? _idSeleccionado;
  int? get idSeleccionado => _idSeleccionado;
  bool _dentrodelarea = false;
  bool get dentrodeArea => _dentrodelarea;
  List<DepartamentoModel> departamentos = [];
  List<DistritoModel> distritos = [];

  Future<void> seleccionarUbicacion(int id) async {
    _idSeleccionado = id;

    print("....seleccionar ubicacion");
    print("id $id");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ubicacionSeleccionada', id);

    // Automáticamente verificar si está fuera de la zona
    await verificacionUbicacionSeleccionada(id);
    notifyListeners();
  }

  Future<void> cargarDepartamentos() async {
    try {
      final url = Uri.parse("$microUrl/alldepartamentos");
      var res = await http.get(url);

      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(res.body);
        departamentos =
            data.map((item) => DepartamentoModel.fromJson(item)).toList();
        print(data);
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print("Error cargando departamentos: $e");
    }
  }

  // Cargar distritos por departamento
  Future<void> cargarDistritos(int departamentoId) async {
    try {
      final url = Uri.parse("$microUrl/alldistritos/$departamentoId");
      var res = await http.get(url);

      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(res.body);
        distritos = data.map((item) => DistritoModel.fromJson(item)).toList();
        print(data);
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print("Error cargando distritos: $e");
    }
  }

  Future<void> verificacionUbicacionSeleccionada(int idUbicacion) async {
    try {
      print(",,,,,verificando si cumples CON EL ÁREA DE REPATO");
      var res = await http.get(
        Uri.parse("$microUrl/ubicacion_seleccionada/$idUbicacion"),
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        _dentrodelarea = true;
        print("dentro del área de reparto");
        notifyListeners();
      } else {
        print("...NO CUMPLES");
        _dentrodelarea = false;
        notifyListeners();
      }
    } catch (e) {
      throw Exception("Error en la verificacion $e");
    }
  }

  Future<void> cargarUbicacionSeleccionada() async {
    final prefs = await SharedPreferences.getInstance();
    _idSeleccionado = prefs.getInt('ubicacionSeleccionada');
    print("selecionadio id");
    print(_idSeleccionado);
    notifyListeners();
  }

  // MÉTODOS
  Future<void> deleteUbicacion(int id) async {
    try {
      var res = await http.delete(
        Uri.parse("$microUrl/eliminar_ubicacion/$id"),
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print("Error en la peticion: $e");
    }
  }

  Future<void> postNewUbicacion({
    required String? distrito,
    required String? departamento,
    required String? direccion,
    required String? etiqueta,
    required double? latitud,
    required double? longitud,
    required String? numero_manzana,
    required int? cliente_id,
  }) async {
    try {
      print("..........dentro del POST PROVIDER");
      print(distrito);
      print(direccion);
      final body = {
        "departamento": departamento,
        "distrito": distrito,
        "direccion": direccion,
        "latitud": latitud,
        "longitud": longitud,
        "cliente_id": cliente_id,
        "etiqueta": etiqueta,
      };

      print("BODY POST: $body");

      var res = await http.post(
        Uri.parse("$microUrl/ubicacion_cliente"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "departamento": departamento,
          "distrito": distrito,
          "direccion": direccion,
          "latitud": latitud,
          "longitud": longitud,
          "cliente_id": cliente_id,
          "etiqueta": etiqueta,
          "numero_manzana": numero_manzana,
        }),
      );
      print(".........CODE HTTP ${res.statusCode}");
      if (res.statusCode == 201) {
        var data = jsonDecode(res.body);
        print(".....DATA POST");
        UbicacionModel nuevaUbicacion = UbicacionModel.fromJson(data);
        _ubicaciones.add(nuevaUbicacion);

        await seleccionarUbicacion(nuevaUbicacion.id!);
        print(data);
        notifyListeners();
      } else if (res.statusCode == 400) {
        throw Exception("Ubicación fuera de cobertura");
      }
      notifyListeners();
    } catch (e) {
      throw Exception("Error en la petición: $e");
    }
  }

  Future<void> updateUbicacion(
    String? departamento,
    String? distrito,
    String? direccion,
    String? numero_manzana,
    String? etiqueta,
    double latitud,
    double longitud,
    int idUbicacion,
  ) async {
    try {
      var res = await http.put(
        Uri.parse("$microUrl/actualizar_ubicacion/$idUbicacion"),
        body: jsonEncode({
          "departamento": departamento,
          "distrito": distrito,
          "direccion": direccion,
          "numero_manzana": numero_manzana,
          "etiqueta": etiqueta,
          "latitud": latitud,
          "longitud": longitud,
        }),
        headers: {"Content-type": "application/json"},
      );
      if (res.statusCode == 200) {
        print("....actualizadoa");
        var data = jsonDecode(res.body);
        final actualizada = UbicacionModel.fromJson(data);

        // Actualiza la lista
        int index = _ubicaciones.indexWhere((u) => u.id == actualizada.id);
        if (index != -1) {
          _ubicaciones[index] = actualizada;
        }

        // Actualiza el temporal con datos frescos
        setTemporal(actualizada);
        // 🔥 Verifica si está dentro del área de reparto
        await verificacionUbicacionSeleccionada(idUbicacion);
      }
      notifyListeners();
    } catch (e) {
      print("Error en la peticion: $e");
    }
  }

  Future<void> ubicacionSeleccionada(int id) async {
    try {
      var res = await http.post(
        Uri.parse('$microUrl/ubicacion_seleccionada/$id'),
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
      }
    } catch (e) {
      throw Exception("Error en la petición: $e");
    }
  }

  Future<void> getUbicaciones(int? cliente_id) async {
    print("...Ubicaciones....");
    _isLoading = true;
    notifyListeners();
    try {
      var res = await http.get(
        Uri.parse('$microUrl/allubicaciones/$cliente_id'),
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        _ubicaciones = List<UbicacionModel>.from(
          data.map((item) => UbicacionModel.fromJson(item)),
        );
        print("Hay ubicaciones");
        /* if (_ubicaciones.isNotEmpty && _idSeleccionado == null) {
          _idSeleccionado = _ubicaciones.last.id;
          print(
              "No había selección previa, se eligió por defecto: $_idSeleccionado");
        }*/
        notifyListeners();
      }

      notifyListeners();
    } catch (e) {
      _ubicaciones = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTemporal(UbicacionModel? ubicaciontemp) {
    _ubicacionTemp = ubicaciontemp;
    print("------TIENE ID =");
    print(ubicaciontemp?.id);
    notifyListeners();
  }

  void clear() {
    _ubicacionTemp = null;
    notifyListeners();
  }

  void limpiarUbicaciones() {
    _ubicaciones = [];
    _idSeleccionado = null;
    _dentrodelarea = false;
    _ubicacionTemp = null;
    notifyListeners();
  }
}
