import 'package:pussy_match/data/dtos/cat_dto.dart';

abstract class CatLocalDataSource {
  Future<List<CatDto>> getCachedCats();
  Future<void> cacheCats(List<CatDto> cats);
  Future<List<CatDto>> getLikedCats();
  Future<void> likeCat(CatDto cat);
  Future<void> unlikeCat(String id);
}