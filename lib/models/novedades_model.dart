class NovedadesModel {
  final int id;
  final String titulo;
  final String descripcion;
  final String terminos;
  final CategoriaNovedad categoria;
  final PromocionNovedad? promocion;
  final ProductoNovedad? producto;

  NovedadesModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.terminos,
    required this.categoria,
    this.promocion,
    this.producto,
  });

  factory NovedadesModel.fromJson(Map<String, dynamic> json) {
    return NovedadesModel(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      terminos: json['terminos_condiciones'],
      categoria: CategoriaNovedad.fromJson(json['categoria']),
      promocion: json['promocion'] != null
          ? PromocionNovedad.fromJson(json['promocion'])
          : null,
      producto: json['producto'] != null
          ? ProductoNovedad.fromJson(json['producto'])
          : null,
    );
  }
}

class PromocionNovedad {
  final int id;
  final List<String> fotos;

  PromocionNovedad({required this.id, required this.fotos});

  factory PromocionNovedad.fromJson(Map<String, dynamic> json) {
    return PromocionNovedad(
      id: json['id'],
      fotos: List<String>.from(json['foto']),
    );
  }
}

class ProductoNovedad {
  final int id;
  final List<String> fotos;

  ProductoNovedad({required this.id, required this.fotos});

  factory ProductoNovedad.fromJson(Map<String, dynamic> json) {
    return ProductoNovedad(
      id: json['id'],
      fotos: List<String>.from(json['foto']),
    );
  }
}

class CategoriaNovedad {
  final int id;
  final String nombre;

  CategoriaNovedad({required this.id, required this.nombre});

  factory CategoriaNovedad.fromJson(Map<String, dynamic> json) {
    return CategoriaNovedad(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}
