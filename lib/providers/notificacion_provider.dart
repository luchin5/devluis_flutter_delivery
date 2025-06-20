import 'dart:convert';
import 'package:app2025_final/models/notificaciones_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificacionProvider extends ChangeNotifier {
  List<NotificacionesModel>? _notificaciones;
  List<NotificacionesModel>? get allnotifycliente => _notificaciones;
  String microUrl = dotenv.env['MICRO_URL'] ?? '';

  int _cant = 0;
  int get cant => _cant;

  void incrementarContador() {
    _cant++;
    notifyListeners();
  }

  void resetContador() {
    _cant = 0;
    notifyListeners();
  }

  Future<void> getNotificaciones() async {
    try {
      var res = await http.get(Uri.parse("$microUrl/notificacion_cliente"));
      if (res.statusCode == 200) {
        print(".....entro a notificacion");
        var data = jsonDecode(res.body);
        final nuevas =
            (data as List).map((e) => NotificacionesModel.fromJson(e)).toList();

        _notificaciones = nuevas;
        _cant = nuevas.length;
        //  _contador = _contador + 1;
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print("Error en la petición $e");
    }
  }
}
