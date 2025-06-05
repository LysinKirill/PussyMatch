import 'dart:convert';

import 'package:pussy_match/domain/entities/cat.dart';

class CatModel {
  final String id;
  final String imageUrl;

  // Breed properties
  final String breedId;
  final String breedName;
  final String breedDescription;
  final String breedTemperament;
  final String breedOrigin;
  final String breedLifeSpan;
  final String breedWeight;
  final int breedAdaptability;
  final int breedAffectionLevel;
  final int breedChildFriendly;
  final int breedDogFriendly;
  final int breedEnergyLevel;
  final int breedHealthIssues;
  final int breedIntelligence;
  final int breedSocialNeeds;
  final int breedStrangerFriendly;
  final int breedVocalisation;
  final String breedWikipediaUrl;

  final DateTime likedTimestamp;

  CatModel({
    required this.id,
    required this.imageUrl,
    required this.breedId,
    required this.breedName,
    required this.breedDescription,
    required this.breedTemperament,
    required this.breedOrigin,
    required this.breedLifeSpan,
    required this.breedWeight,
    required this.breedAdaptability,
    required this.breedAffectionLevel,
    required this.breedChildFriendly,
    required this.breedDogFriendly,
    required this.breedEnergyLevel,
    required this.breedHealthIssues,
    required this.breedIntelligence,
    required this.breedSocialNeeds,
    required this.breedStrangerFriendly,
    required this.breedVocalisation,
    required this.breedWikipediaUrl,
    DateTime? likedTimestamp,
  }) : likedTimestamp = likedTimestamp ?? DateTime.now();

  factory CatModel.fromEntity(Cat cat) {
    return CatModel(
      id: cat.id,
      imageUrl: cat.imageUrl,
      breedId: cat.breed.id,
      breedName: cat.breed.name,
      breedDescription: cat.breed.description,
      breedTemperament: cat.breed.temperament,
      breedOrigin: cat.breed.origin,
      breedLifeSpan: cat.breed.lifeSpan,
      breedWeight: jsonEncode(cat.breed.weight),
      breedAdaptability: cat.breed.adaptability,
      breedAffectionLevel: cat.breed.affectionLevel,
      breedChildFriendly: cat.breed.childFriendly,
      breedDogFriendly: cat.breed.dogFriendly,
      breedEnergyLevel: cat.breed.energyLevel,
      breedHealthIssues: cat.breed.healthIssues,
      breedIntelligence: cat.breed.intelligence,
      breedSocialNeeds: cat.breed.socialNeeds,
      breedStrangerFriendly: cat.breed.strangerFriendly,
      breedVocalisation: cat.breed.vocalisation,
      breedWikipediaUrl: cat.breed.wikipediaUrl,
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
        temperament: breedTemperament,
        origin: breedOrigin,
        lifeSpan: breedLifeSpan,
        weight: jsonDecode(breedWeight),
        adaptability: breedAdaptability,
        affectionLevel: breedAffectionLevel,
        childFriendly: breedChildFriendly,
        dogFriendly: breedDogFriendly,
        energyLevel: breedEnergyLevel,
        healthIssues: breedHealthIssues,
        intelligence: breedIntelligence,
        socialNeeds: breedSocialNeeds,
        strangerFriendly: breedStrangerFriendly,
        vocalisation: breedVocalisation,
        wikipediaUrl: breedWikipediaUrl,
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
      'breedTemperament': breedTemperament,
      'breedOrigin': breedOrigin,
      'breedLifeSpan': breedLifeSpan,
      'breedWeight': breedWeight,
      'breedAdaptability': breedAdaptability,
      'breedAffectionLevel': breedAffectionLevel,
      'breedChildFriendly': breedChildFriendly,
      'breedDogFriendly': breedDogFriendly,
      'breedEnergyLevel': breedEnergyLevel,
      'breedHealthIssues': breedHealthIssues,
      'breedIntelligence': breedIntelligence,
      'breedSocialNeeds': breedSocialNeeds,
      'breedStrangerFriendly': breedStrangerFriendly,
      'breedVocalisation': breedVocalisation,
      'breedWikipediaUrl': breedWikipediaUrl,
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
      breedTemperament: map['breedTemperament'],
      breedOrigin: map['breedOrigin'],
      breedLifeSpan: map['breedLifeSpan'],
      breedWeight: map['breedWeight'],
      breedAdaptability: map['breedAdaptability'],
      breedAffectionLevel: map['breedAffectionLevel'],
      breedChildFriendly: map['breedChildFriendly'],
      breedDogFriendly: map['breedDogFriendly'],
      breedEnergyLevel: map['breedEnergyLevel'],
      breedHealthIssues: map['breedHealthIssues'],
      breedIntelligence: map['breedIntelligence'],
      breedSocialNeeds: map['breedSocialNeeds'],
      breedStrangerFriendly: map['breedStrangerFriendly'],
      breedVocalisation: map['breedVocalisation'],
      breedWikipediaUrl: map['breedWikipediaUrl'],
      likedTimestamp: DateTime.fromMillisecondsSinceEpoch(
        map['likedTimestamp'],
      ),
    );
  }
}
