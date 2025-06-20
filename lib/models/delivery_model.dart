class DeliveryModel {
  int id;
  int precio;
  String nombre;

  DeliveryModel({required this.id, required this.precio, required this.nombre});

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'],
      precio: json['precio'],
      nombre: json['nombre'],
    );
  }
}
