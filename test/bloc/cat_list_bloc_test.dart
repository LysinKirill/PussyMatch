import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pussy_match/domain/entities/cat.dart';
import 'package:pussy_match/domain/usecases/get_cats.dart';
import 'package:pussy_match/presentation/bloc/cat_list/cat_list_bloc.dart';

class MockGetCats extends Mock implements GetCats {}

void main() {
  late MockGetCats mockGetCats;
  late List<Cat> testCats;

  setUp(() {
    mockGetCats = MockGetCats();
    testCats = List.generate(
      3,
      (i) => Cat(
        id: '$i',
        imageUrl: 'url$i',
        breed: CatBreed(
          id: 'b$i',
          name: 'Breed $i',
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
      ),
    );
  });

  group('CatListBloc', () {
    blocTest<CatListBloc, CatListState>(
      'emits [CatListLoaded] with cats on LoadRandomCats',
      build: () {
        when(() => mockGetCats(limit: 10)).thenAnswer((_) async => testCats);
        return CatListBloc(getCats: mockGetCats);
      },
      act: (bloc) => bloc.add(LoadRandomCats()),
      expect: () => [CatListLoading(), CatListLoaded(cats: testCats)],
    );
  });
}
