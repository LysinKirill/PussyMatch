import '../entities/cat.dart';

abstract class CatRepository {
  Future<List<Cat>> getRandomCats(int limit);
  Future<void> likeCat(Cat cat);
  Future<void> unlikeCat(String catId);
  Future<List<Cat>> getLikedCats();
  Future<List<Cat>> getLikedCatsByBreed(String breedId);
}
