class BannerModel {
  int id;
  String foto;
  String titulo;
  String descripcion;
  String restriccion;

  BannerModel(
      {required this.id,
      required this.foto,
      required this.titulo,
      required this.descripcion,
      required this.restriccion});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
        id: json['id'],
        titulo: json['titulo'] ?? '',
        foto: json['foto'] ?? '',
        descripcion: json['descripcion'] ?? '',
        restriccion: json['restriccion'] ?? '');
  }
}
