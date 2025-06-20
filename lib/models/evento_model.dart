import 'package:app2025_final/models/banner_model.dart';

class EventobannerModel {
  //ATRIBUTOS
  int id;
  String titulo;
  String fondofoto;
  List<BannerModel> banners;

  //CONSTRUCTOR
  EventobannerModel({
    required this.id,
    required this.titulo,
    required this.fondofoto,
    required this.banners,
  });

  factory EventobannerModel.fromJson(Map<String, dynamic> json) {
    return EventobannerModel(
      id: json['id'],
      titulo: json['titulo'] ?? '',
      fondofoto: json['fondo'] ?? '',
      banners:
          (json['banners'] as List)
              .map((b) => BannerModel.fromJson(b))
              .toList(),
    );
  }
}
