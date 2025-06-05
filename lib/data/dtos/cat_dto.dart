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
  final Map<String, dynamic> weight;
  final int adaptability;
  final int affectionLevel;
  final int childFriendly;
  final int dogFriendly;
  final int energyLevel;
  final int healthIssues;
  final int intelligence;
  final int socialNeeds;
  final int strangerFriendly;
  final int vocalisation;
  final String wikipediaUrl;

  BreedDto({
    required this.id,
    required this.name,
    required this.description,
    required this.temperament,
    required this.origin,
    required this.lifeSpan,
    required this.weight,
    required this.adaptability,
    required this.affectionLevel,
    required this.childFriendly,
    required this.dogFriendly,
    required this.energyLevel,
    required this.healthIssues,
    required this.intelligence,
    required this.socialNeeds,
    required this.strangerFriendly,
    required this.vocalisation,
    required this.wikipediaUrl,
  });

  factory BreedDto.fromJson(Map<String, dynamic> json) {
    return BreedDto(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      temperament: json['temperament'],
      origin: json['origin'],
      lifeSpan: json['life_span'],
      weight: json['weight'],
      adaptability: json['adaptability'],
      affectionLevel: json['affection_level'],
      childFriendly: json['child_friendly'],
      dogFriendly: json['dog_friendly'],
      energyLevel: json['energy_level'],
      healthIssues: json['health_issues'],
      intelligence: json['intelligence'],
      socialNeeds: json['social_needs'],
      strangerFriendly: json['stranger_friendly'],
      vocalisation: json['vocalisation'],
      wikipediaUrl: json['wikipedia_url'] ?? '',
    );
  }
}

