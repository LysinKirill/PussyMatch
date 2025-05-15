import '../repositories/cat_repository.dart';
import '../entities/cat.dart';

class LikeCat {
  final CatRepository repository;

  LikeCat({required this.repository});

  Future<void> call(Cat cat) async {
    return await repository.likeCat(cat);
  }
}