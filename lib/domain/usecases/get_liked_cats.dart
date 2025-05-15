import '../repositories/cat_repository.dart';
import '../entities/cat.dart';

class GetLikedCats {
  final CatRepository repository;

  GetLikedCats({required this.repository});

  Future<List<Cat>> call() async {
    return await repository.getLikedCats();
  }
}