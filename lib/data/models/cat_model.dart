import 'package:pussy_match/domain/entities/cat.dart';

class CatModel {
  final String id;
  final String imageUrl;
  final String breedId;
  final String breedName;
  final String breedDescription;
  final DateTime likedTimestamp;

  CatModel({
    required this.id,
    required this.imageUrl,
    required this.breedId,
    required this.breedName,
    required this.breedDescription,
    DateTime? likedTimestamp,
  }) : likedTimestamp = likedTimestamp ?? DateTime.now();

  factory CatModel.fromEntity(Cat cat) {
    return CatModel(
      id: cat.id,
      imageUrl: cat.imageUrl,
      breedId: cat.breed.id,
      breedName: cat.breed.name,
      breedDescription: cat.breed.description,
      likedTimestamp: cat.likedTimestamp,
    );
  }

  Cat toEntity() {
    return Cat(
      id: id,
      imageUrl: imageUrl,
      breed: CatBreed(
        id: breedId,
        name: breedName,
        description: breedDescription,
        // Add other breed properties with default values
        temperament: '',
        origin: '',
        lifeSpan: '',
        weight: {},
        adaptability: 0,
        affectionLevel: 0,
        childFriendly: 0,
        dogFriendly: 0,
        energyLevel: 0,
        healthIssues: 0,
        intelligence: 0,
        socialNeeds: 0,
        strangerFriendly: 0,
        vocalisation: 0,
        wikipediaUrl: '',
      ),
      likedTimestamp: likedTimestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'breedId': breedId,
      'breedName': breedName,
      'breedDescription': breedDescription,
      'likedTimestamp': likedTimestamp.millisecondsSinceEpoch,
    };
  }

  factory CatModel.fromMap(Map<String, dynamic> map) {
    return CatModel(
      id: map['id'],
      imageUrl: map['imageUrl'],
      breedId: map['breedId'],
      breedName: map['breedName'],
      breedDescription: map['breedDescription'],
      likedTimestamp: DateTime.fromMillisecondsSinceEpoch(map['likedTimestamp']),
    );
  }
}