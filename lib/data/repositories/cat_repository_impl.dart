import '../../domain/entities/cat.dart';
import '../../domain/repositories/cat_repository.dart';
import '../datasources/cat_remote_data_source.dart';
import '../dtos/cat_dto.dart';

class CatRepositoryImpl implements CatRepository {
  final CatRemoteDataSource remoteDataSource;
  final List<Cat> _likedCats = [];

  CatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Cat>> getRandomCats(int limit) async {
    final catDtos = await remoteDataSource.getRandomCats(limit);
    return catDtos.map(_mapDtoToEntity).toList();
  }

  @override
  Future<void> likeCat(Cat cat) async {
    _likedCats.add(cat);
  }

  @override
  Future<void> unlikeCat(String catId) async {
    _likedCats.removeWhere((cat) => cat.id == catId);
  }

  @override
  Future<List<Cat>> getLikedCats() async {
    return List.from(_likedCats);
  }

  @override
  Future<List<Cat>> getLikedCatsByBreed(String breedId) async {
    return _likedCats.where((cat) => cat.breed.id == breedId).toList();
  }

  Cat _mapDtoToEntity(CatDto dto) {
    final breedDto = BreedDto.fromJson(dto.breeds.first);
    return Cat(
      id: dto.id,
      imageUrl: dto.url,
      breed: CatBreed(
        id: breedDto.id,
        name: breedDto.name,
        description: breedDto.description,
        temperament: breedDto.temperament,
        origin: breedDto.origin,
        lifeSpan: breedDto.lifeSpan,
        adaptability: breedDto.adaptability,
        affectionLevel: breedDto.affectionLevel,
        childFriendly: breedDto.childFriendly,
        dogFriendly: breedDto.dogFriendly,
        energyLevel: breedDto.energyLevel,
        healthIssues: breedDto.healthIssues,
        intelligence: breedDto.intelligence,
        socialNeeds: breedDto.socialNeeds,
        strangerFriendly: breedDto.strangerFriendly,
        vocalisation: breedDto.vocalisation,
        wikipediaUrl: breedDto.wikipediaUrl,
        weight: breedDto.weight
      ),
    );
  }
}