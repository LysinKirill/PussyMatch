import 'package:pussy_match/data/datasources/local/cat_local_data_source.dart';
import '../../domain/entities/cat.dart';
import '../../domain/repositories/cat_repository.dart';
import '../datasources/cat_remote_data_source.dart';
import '../models/cat_model.dart';

class CatRepositoryImpl implements CatRepository {
  final CatRemoteDataSource remoteDataSource;
  final CatLocalDataSource localDataSource;

  CatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Cat>> getRandomCats(int limit) async {
    try {
      final catDtos = await remoteDataSource.getRandomCats(limit);
      final cats = catDtos.map((dto) => dto.toEntity()).toList();
      await localDataSource.cacheCats(cats.map(CatModel.fromEntity).toList());
      return cats;
    } catch (e) {
      final cached = await localDataSource.getCachedCats();
      if (cached.isNotEmpty)
        return cached.map((model) => model.toEntity()).toList();
      return [];
    }
  }

  @override
  Future<void> likeCat(Cat cat) async {
    await localDataSource.likeCat(CatModel.fromEntity(cat));
  }

  @override
  Future<void> unlikeCat(String catId) async {
    await localDataSource.unlikeCat(catId);
  }

  @override
  Future<List<Cat>> getLikedCats() async {
    final likedCats = await localDataSource.getLikedCats();
    return likedCats.map((cat) => cat.toEntity()).toList();
  }

  @override
  Future<List<Cat>> getLikedCatsByBreed(String breedId) async {
    final likedCats = await getLikedCats();
    return likedCats.where((cat) => cat.breed.id == breedId).toList();
  }
}
