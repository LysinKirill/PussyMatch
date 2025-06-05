import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pussy_match/domain/entities/cat.dart';
import 'package:pussy_match/presentation/bloc/liked_cats/liked_cats_bloc.dart';
import '../mocks/mock_cat_repository.dart';

void main() {
  late MockGetLikedCats mockGetLikedCats;
  late MockLikeCat mockLikeCat;
  late MockUnlikeCat mockUnlikeCat;
  late Cat testCat;

  setUp(() {
    mockGetLikedCats = MockGetLikedCats();
    mockLikeCat = MockLikeCat();
    mockUnlikeCat = MockUnlikeCat();

    testCat = Cat(
      id: '1',
      imageUrl: 'url',
      breed: CatBreed(
        id: 'b1',
        name: 'Test Breed',
        description: '',
        temperament: '',
        origin: '',
        lifeSpan: '',
        weight: {},
        adaptability: 1,
        affectionLevel: 1,
        childFriendly: 1,
        dogFriendly: 1,
        strangerFriendly: 1,
        energyLevel: 1,
        healthIssues: 1,
        intelligence: 1,
        socialNeeds: 1,
        vocalisation: 1,
        wikipediaUrl: '',
      ),
    );

    registerFallbackValue(testCat);
    registerFallbackValue('1');
  });

  group('LikedCatsBloc', () {
    blocTest<LikedCatsBloc, LikedCatsState>(
      'emits [LikedCatsLoaded] when LoadLikedCats succeeds',
      build: () {
        when(() => mockGetLikedCats()).thenAnswer((_) async => [testCat]);
        return LikedCatsBloc(
          getLikedCats: mockGetLikedCats,
          likeCat: mockLikeCat,
          unlikeCat: mockUnlikeCat,
        );
      },
      act: (bloc) => bloc.add(LoadLikedCats()),
      expect:
          () => [
            LikedCatsLoading(),
            LikedCatsLoaded(cats: [testCat], filteredBreedId: null),
          ],
    );

    blocTest<LikedCatsBloc, LikedCatsState>(
      'adds cat to liked list on AddLikedCat',
      build: () {
        when(() => mockGetLikedCats()).thenAnswer((_) async => [testCat]);
        when(() => mockLikeCat(testCat)).thenAnswer((_) async {});
        return LikedCatsBloc(
          getLikedCats: mockGetLikedCats,
          likeCat: mockLikeCat,
          unlikeCat: mockUnlikeCat,
        );
      },
      seed: () => LikedCatsLoaded(cats: [], filteredBreedId: null),
      act: (bloc) => bloc.add(AddLikedCat(cat: testCat)),
      expect:
          () => [
            LikedCatsLoaded(cats: [testCat], filteredBreedId: null),
          ],
      verify: (_) {
        verify(() => mockLikeCat(testCat)).called(1);
      },
    );

    blocTest<LikedCatsBloc, LikedCatsState>(
      'removes cat on RemoveLikedCat',
      build: () {
        when(() => mockUnlikeCat('1')).thenAnswer((_) async {});
        return LikedCatsBloc(
          getLikedCats: mockGetLikedCats,
          likeCat: mockLikeCat,
          unlikeCat: mockUnlikeCat,
        );
      },
      seed: () => LikedCatsLoaded(cats: [testCat], filteredBreedId: null),
      act: (bloc) => bloc.add(RemoveLikedCat(catId: '1')),
      expect: () => [LikedCatsLoaded(cats: [], filteredBreedId: null)],
      verify: (_) {
        verify(() => mockUnlikeCat('1')).called(1);
      },
    );
  });
}
