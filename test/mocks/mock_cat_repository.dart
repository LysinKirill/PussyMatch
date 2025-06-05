import 'package:mocktail/mocktail.dart';
import 'package:pussy_match/domain/usecases/get_liked_cats.dart';
import 'package:pussy_match/domain/usecases/like_cat.dart';
import 'package:pussy_match/domain/usecases/unlike_cat.dart';

class MockGetLikedCats extends Mock implements GetLikedCats {}

class MockLikeCat extends Mock implements LikeCat {}

class MockUnlikeCat extends Mock implements UnlikeCat {}
