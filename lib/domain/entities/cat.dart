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
  final int adaptability;
  final int affectionLevel;
  final int intelligence;

  CatBreed({
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
}