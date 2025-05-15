import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/cat.dart';
import '../../../domain/usecases/get_liked_cats.dart';
import '../../../domain/usecases/like_cat.dart';
import '../../../domain/usecases/unlike_cat.dart';

part 'liked_cats_event.dart';
part 'liked_cats_state.dart';

class LikedCatsBloc extends Bloc<LikedCatsEvent, LikedCatsState> {
  final GetLikedCats getLikedCats;
  final LikeCat likeCat;
  final UnlikeCat unlikeCat;

  LikedCatsBloc({
    required this.getLikedCats,
    required this.likeCat,
    required this.unlikeCat,
  }) : super(LikedCatsInitial()) {
    on<LoadLikedCats>(_onLoadLikedCats);
    on<AddLikedCat>(_onAddLikedCat);
    on<RemoveLikedCat>(_onRemoveLikedCat);
    on<FilterLikedCatsByBreed>(_onFilterLikedCatsByBreed);
  }

  Future<void> _onLoadLikedCats(
      LoadLikedCats event,
      Emitter<LikedCatsState> emit,
      ) async {
    emit(LikedCatsLoading());
    try {
      final cats = await getLikedCats();
      emit(LikedCatsLoaded(cats: cats));
    } catch (e) {
      emit(LikedCatsError(message: e.toString()));
    }
  }

  Future<void> _onAddLikedCat(
      AddLikedCat event,
      Emitter<LikedCatsState> emit,
      ) async {
    await likeCat(event.cat);
    if (state is LikedCatsLoaded) {
      final currentState = state as LikedCatsLoaded;
      emit(LikedCatsLoaded(
        cats: [...currentState.cats, event.cat],
        filteredBreedId: currentState.filteredBreedId,
      ));
    }
  }

  Future<void> _onRemoveLikedCat(
      RemoveLikedCat event,
      Emitter<LikedCatsState> emit,
      ) async {
    await unlikeCat(event.catId);
    if (state is LikedCatsLoaded) {
      final currentState = state as LikedCatsLoaded;
      emit(LikedCatsLoaded(
        cats: currentState.cats.where((cat) => cat.id != event.catId).toList(),
        filteredBreedId: currentState.filteredBreedId,
      ));
    }
  }

  Future<void> _onFilterLikedCatsByBreed(
      FilterLikedCatsByBreed event,
      Emitter<LikedCatsState> emit,
      ) async {
    if (state is LikedCatsLoaded) {
      final currentState = state as LikedCatsLoaded;
      final cats = await getLikedCats();
      final filteredCats = event.breedId == null
          ? cats
          : cats.where((cat) => cat.breed.id == event.breedId).toList();

      emit(LikedCatsLoaded(
        cats: filteredCats,
        filteredBreedId: event.breedId,
      ));
    }
  }
}