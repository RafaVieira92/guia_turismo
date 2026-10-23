class LugaresModel {
  final int id;
  final String nome;
  final String? categoria;
  final double latitude;
  final double longitude;
  final String descricao;
  final int categoriaId;
 
  LugaresModel({
    required this.id,
    required this.nome,
    this.categoria,
    required this.categoriaId,
    required this.latitude,
    required this.longitude,
    this.descricao = '',
  });
 
  factory LugaresModel.fromJson(Map<String, dynamic> json) {
    final categoriaJson = json['categoria'];
    final categoria = categoriaJson is Map<String, dynamic>
        ? categoriaJson['nome']?.toString()
        : categoriaJson?.toString();
    double parseCoordenada(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    return LugaresModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nome: json['nome']?.toString() ?? '',
      categoria: categoria,
      latitude: parseCoordenada(json['latitude']),
      longitude: parseCoordenada(json['longitude']),
      descricao: json['descricao']?.toString() ?? '',
      categoriaId: (json['categoria_id'] as num?)?.toInt() ?? 0,
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'categoria': categoria,
      'latitude': latitude,
      'longitude': longitude,
      'descricao': descricao,
      'categoria_id': categoriaId,
    };
  }
}