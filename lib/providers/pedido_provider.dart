import 'dart:convert';
import 'package:app2025_final/models/codigos_model.dart';
import 'package:app2025_final/models/historial_model.dart';
import 'package:app2025_final/models/pedido_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PedidoProvider extends ChangeNotifier {
  PedidoModel? _pedido;
  PedidoModel? get allpedidos => _pedido;
  List<PedidoModel>? _pedidoshoy = [];
  List<PedidoModel>? get allpedidoshoy => _pedidoshoy;

  List<HistorialModel>? _historial = [];
  List<HistorialModel>? get allhistorial => _historial;

  String microUrl = dotenv.env['MICRO_URL'] ?? '';
  CodigoDescuentoModel? _codigoVerificado;
  CodigoDescuentoModel? get codigoVerificado => _codigoVerificado;

  void setearCodigoDescuento() {
    _codigoVerificado = null;
    notifyListeners();
  }

  // FUNCIÓN DE VALIDACIÓN DE CÓDIGO
  Future<bool> verificarCodigo(String codigo) async {
    try {
      final url = Uri.parse("$microUrl/verificar_codigo?codigo=$codigo");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _codigoVerificado = CodigoDescuentoModel.fromJson(data);
        notifyListeners();
        return true;
      } else {
        _codigoVerificado = null;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Error verificando código: $e");
      _codigoVerificado = null;
      notifyListeners();
      return false;
    }
  }

  Future<void> putEstadoAnulado(int id) async {
    try {
      print(",,,anulando");
      print(id);
      var res = await http.put(
        Uri.parse("$microUrl/pedido_anulado/${id}"),
        headers: {"Content-type": "application/json"},
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print("...anulado ");
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print("Error en la peticion : $e");
    }
  }

  Future<void> postPedido({
    int? clienteId,

    required String estado,
    required String observacion,
    required String tipoPago,
    int? ubicacionId,
    int? cuponId,
    required int deliveryId,
    int? codigoId,
    required double total,
    required List<Map<String, dynamic>> detalles,
  }) async {
    try {
      final url = Uri.parse("$microUrl/pedido");
      final body = jsonEncode({
        "cliente_id": clienteId,

        "estado": estado,
        "observacion": observacion,
        "tipo_pago": tipoPago,
        "ubicacion_id": ubicacionId,
        "cupon_id": cuponId,
        "delivery_id": deliveryId,
        "codigo_id": codigoId,
        "total": total,
        "detalles": detalles,
      });

      final res = await http.post(
        url,
        body: body,
        headers: {"Content-type": "application/json"},
      );

      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);
        print("....data PEDIDO POSTEADA");
        print(data);
        // Aquí puedes parsear `data` a tu modelo PedidoModel si quieres
        // _pedido = PedidoModel.fromJson(data);
        notifyListeners();
      } else {
        print("Error al crear pedido: ${res.body}");
      }
    } catch (e) {
      print("Error en la petición $e");
    }
  }

  Future<void> fetchHistorialPedidos(int clienteId) async {
    try {
      print("...$clienteId");
      //final clinetID = 4;
      final url = Uri.parse("$microUrl/pedido_history_cliente/${clienteId}");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        _historial =
            (data as List).map((e) => HistorialModel.fromJson(e)).toList();
        /* final List<dynamic> data = jsonDecode(res.body);
        _historialPedidos =
            data.map((pedido) => PedidoHistoryModel.fromJson(pedido)).toList();*/
        notifyListeners();
      } else {
        print("Error al obtener historial: ${res.body}");
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print("Error en la petición: $e");
    }
  }
}
