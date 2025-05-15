import '../repositories/cat_repository.dart';

class UnlikeCat {
  final CatRepository repository;

  UnlikeCat({required this.repository});

  Future<void> call(String catId) async {
    return await repository.unlikeCat(catId);
  }
}