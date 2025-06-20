import 'dart:convert';

import 'package:app2025_final/models/clientecompleto_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ClienteProvider extends ChangeNotifier {
  //ATRIBUTOS
  ClienteCompletoModel? _cliente;
  ClienteCompletoModel? get clienteActual => _cliente;
  String microUrl = dotenv.env['MICRO_URL'] ?? '';
  // CONSTRUCTOR
  ClienteProvider() {
    print("....CLIENTE INICIADO....");
  }

  //MÉTODOS
  Future<void> putTelefono(String telefono) async {
    print("...dentro dle put provider");
    print(telefono);
    try {
      final firebaseuid = _cliente?.user.firebaseUid;
      var res = await http.put(
        Uri.parse("$microUrl/userfirebase_phone/$firebaseuid"),
        body: jsonEncode({"telefono": telefono}),
        headers: {"Content-Type": "Application/json"},
      );
      if (res.statusCode == 200) {
        print("...listo psuhesado");
        await fetchClientePorFirebaseUid(firebaseuid!);
        print("...finalizae");
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      throw Exception("Error en la peticion: $e");
    }
  }

  Future<void> postClienteData({
    required String email,
    required String telefono,
    required String nombres,
    required String apellidos,
    String? foto,
    String? firebase_uid,
  }) async {
    print(".......dentro de registro de cliente");
    try {
      var res = await http.post(
        Uri.parse("$microUrl/register_cliente"),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({
          "user": {
            "rol_id": 4,
            "email": email,
            "telefono": telefono,
            if (firebase_uid != null) "firebase_uid": firebase_uid,
          },
          "cliente": {
            "nombres": nombres,
            "apellidos": apellidos,
            "foto_cliente":
                foto ??
                "https://solvida.sfo3.cdn.digitaloceanspaces.com/7fc4c6ecc7738247aac61a60958429d4-removebg-preview.png",
          },
        }),
      );
      if (res.statusCode == 201) {
        print("""entrando en el el post de clinet data""");
        var data = jsonDecode(res.body);
        print(".....entre con la data");
        print(data);
        _cliente = ClienteCompletoModel.fromJson(data);

        //    setClienteCompleto(_cliente!);

        print("...termine : $_cliente");
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      throw Exception("Error en la petición: $e");
    }
  }

  Future<void> fetchClientePorFirebaseUid(String firebaseUid) async {
    print("///dentro del fetch............");
    try {
      final res = await http.get(
        Uri.parse('$microUrl/userfirebase/$firebaseUid'),
      );
      print("......CUERTPO ${res.body}");

      if (res.statusCode == 200) {
        print("...fetch 200");
        final data = jsonDecode(res.body);
        print(data);
        _cliente = ClienteCompletoModel.fromJson(data);
        print("fetch 20'0");
        notifyListeners();
      } else if (res.statusCode == 404) {
        print("ffetch 404");
        _cliente = null; // Cliente no encontrado
        notifyListeners();
      } else {
        throw Exception('Código inesperado: ${res.statusCode}');
      }
      notifyListeners();
    } catch (e) {
      print('❌ Error al recuperar cliente: $e');
      _cliente = null;
      notifyListeners(); // Para evitar que se quede en estado antiguo
    }
  }

  //
  void setClienteCompleto(ClienteCompletoModel clientein) {
    _cliente = ClienteCompletoModel(
      user: clientein.user,
      cliente: clientein.cliente,
    );
    notifyListeners();
  }

  void limpiarCliente() {
    _cliente = null;
    notifyListeners();
  }
}
