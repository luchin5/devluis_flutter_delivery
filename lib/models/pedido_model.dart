class PedidoModel {
  final int clienteId;
  final String fecha;
  final String estado;
  final String observacion;
  final String tipoPago;
  final int ubicacionId;
  final int? cuponId;
  final int? deliveryId;
  final int? codigoId;
  final double total;
  final List<DetallePedido> detalles;

  PedidoModel({
    required this.clienteId,
    required this.fecha,
    required this.estado,
    required this.observacion,
    required this.tipoPago,
    required this.ubicacionId,
    this.cuponId,
    this.deliveryId,
    this.codigoId,
    required this.total,
    required this.detalles,
  });

  Map<String, dynamic> toJson() => {
    "cliente_id": clienteId,
    "fecha": fecha,
    "estado": estado,
    "observacion": observacion,
    "tipo_pago": tipoPago,
    "ubicacion_id": ubicacionId,
    "cupon_id": cuponId,
    "delivery_id": deliveryId,
    "codigo_id": codigoId,
    "total": total,
    "detalles": detalles.map((d) => d.toJson()).toList(),
  };
}

class DetallePedido {
  final int? productoId;
  int cantidad;
  final int? promocionId;

  DetallePedido({
    required this.productoId,
    required this.cantidad,
    this.promocionId,
  });

  Map<String, dynamic> toJson() => {
    "producto_id": productoId,
    "cantidad": cantidad,
    "promocion_id": promocionId,
  };
}
