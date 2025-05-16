class Cat {
  final String id;
  final String imageUrl;
  final CatBreed breed;
  final DateTime likedTimestamp;

  Cat({
    required this.id,
    required this.imageUrl,
    required this.breed,
    DateTime? likedTimestamp,
  }) : likedTimestamp = likedTimestamp ?? DateTime.now();
}

class CatBreed {
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

  CatBreed({
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
}