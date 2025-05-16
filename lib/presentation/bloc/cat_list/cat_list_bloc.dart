import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/cat.dart';
import '../../../domain/usecases/get_cats.dart';

part 'cat_list_event.dart';
part 'cat_list_state.dart';

class CatListBloc extends Bloc<CatListEvent, CatListState> {
  final GetCats getCats;
  final int bufferSize = 5;

  CatListBloc({required this.getCats}) : super(CatListInitial()) {
    on<LoadRandomCats>(_onLoadRandomCats);
    on<CatSwiped>(_onCatSwiped);
  }

  Future<void> _onLoadRandomCats(
      LoadRandomCats event,
      Emitter<CatListState> emit,
      ) async {
    emit(CatListLoading());
    try {
      final cats = await getCats(limit: event.limit);
      if (cats.isEmpty) {
        emit(CatListError(message: 'No cats found'));
      } else {
        emit(CatListLoaded(cats: cats));
      }
    } catch (e) {
      emit(CatListError(message: e.toString()));
    }
  }

  Future<void> _onCatSwiped(CatSwiped event, Emitter<CatListState> emit) async {
    if (state is CatListLoaded) {
      final currentState = state as CatListLoaded;
      final newIndex =
          (currentState.currentIndex + 1) % currentState.cats.length;

      // Load more cats if we're nearing the end of the buffer
      if (newIndex >= currentState.cats.length - 2) {
        final moreCats = await getCats(limit: 2);
        emit(
          CatListLoaded(
            cats: [...currentState.cats, ...moreCats],
            currentIndex: newIndex,
          ),
        );
      } else {
        emit(currentState.copyWith(currentIndex: newIndex));
      }
    }
  }
}