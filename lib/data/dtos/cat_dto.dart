class CatDto {
  final String id;
  final String url;
  final List<Map<String, dynamic>> breeds;

  CatDto({
    required this.id,
    required this.url,
    required this.breeds,
  });

  factory CatDto.fromJson(Map<String, dynamic> json) {
    return CatDto(
      id: json['id'],
      url: json['url'],
      breeds: List<Map<String, dynamic>>.from(json['breeds']),
    );
  }
}

class BreedDto {
  final String id;
  final String name;
  final String description;
  final String temperament;
  final String origin;
  final String lifeSpan;
  final int adaptability;
  final int affectionLevel;
  final int intelligence;

  BreedDto({
    required this.id,
    required this.name,
    required this.description,
    required this.temperament,
    required this.origin,
    required this.lifeSpan,
    required this.adaptability,
    required this.affectionLevel,
    required this.intelligence,
  });

  factory BreedDto.fromJson(Map<String, dynamic> json) {
    return BreedDto(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      temperament: json['temperament'],
      origin: json['origin'],
      lifeSpan: json['life_span'],
      adaptability: json['adaptability'],
      affectionLevel: json['affection_level'],
      intelligence: json['intelligence'],
    );
  }
}