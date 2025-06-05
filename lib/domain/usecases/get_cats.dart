import '../repositories/cat_repository.dart';
import '../entities/cat.dart';

class GetCats {
  final CatRepository repository;

  GetCats({required this.repository});

  Future<List<Cat>> call({int limit = 10}) async {
    return await repository.getRandomCats(limit);
  }
}
