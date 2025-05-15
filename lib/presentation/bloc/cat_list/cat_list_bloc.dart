import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/cat.dart';
import '../../../domain/usecases/get_cats.dart';

part 'cat_list_event.dart';
part 'cat_list_state.dart';

class CatListBloc extends Bloc<CatListEvent, CatListState> {
  final GetCats getCats;

  CatListBloc({required this.getCats}) : super(CatListInitial()) {
    on<LoadRandomCats>(_onLoadRandomCats);
  }

  Future<void> _onLoadRandomCats(
      LoadRandomCats event,
      Emitter<CatListState> emit,
      ) async {
    emit(CatListLoading());
    try {
      final cats = await getCats(limit: event.limit);
      emit(CatListLoaded(cats: cats));
    } catch (e) {
      emit(CatListError(message: e.toString()));
    }
  }
}