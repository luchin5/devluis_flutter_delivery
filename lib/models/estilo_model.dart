class EstiloModel {
  int? id;
  List<ColorItem> colores;

  EstiloModel({required this.id, required this.colores});

  factory EstiloModel.fromJson(Map<String, dynamic> json) {
    return EstiloModel(
      id: json['id'],
      colores: (json['colores'] as List)
          .map((item) => ColorItem.fromJson(item))
          .toList(),
    );
  }
}

class ColorItem {
  String key;
  String value;

  ColorItem({required this.key, required this.value});

  factory ColorItem.fromJson(Map<String, dynamic> json) {
    final entry = json.entries.first;
    return ColorItem(
      key: entry.key,
      value: entry.value,
    );
  }
}
