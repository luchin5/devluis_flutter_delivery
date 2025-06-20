import 'package:app2025_final/providers/ubicacion_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IniciarappProvider extends ChangeNotifier {
  //ATRIBUTOS
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SharedPreferences usuarioPrefs;

  //CONSTRUCTOR POR PARÁMETRO
  IniciarappProvider(this.usuarioPrefs);

  // MÉTODOS
  Future<String> determinarRutaInicial(BuildContext context) async {
    final user = _auth.currentUser;
    if (user == null) {
      return '/';
    }
    final tieneUbicacion =
        Provider.of<UbicacionProvider>(
          context,
          listen: false,
        ).allubicaciones.isNotEmpty;
    final esNuevo = user.metadata.creationTime == user.metadata.lastSignInTime;
    final tieneNumero =
        (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) ||
        usuarioPrefs.containsKey('telefono');

    // final tieneUbicacion = usuarioPrefs.containsKey('ubicacion');
    // final tieneUbicacion = Provider.of<UbicacionProvider>(context,listen:false).
    if (esNuevo) {
      print("si soy nuevo");
    } else {
      print("no soy nuevo");
    }
    if (esNuevo || !tieneNumero) {
      return '/editarperfil';
    }
    if (!tieneUbicacion) {
      return '/location';
    }
    return '/barracliente';
  }
}
