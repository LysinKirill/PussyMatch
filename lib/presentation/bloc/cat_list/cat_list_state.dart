part of 'cat_list_bloc.dart';

abstract class CatListState extends Equatable {
  const CatListState();

  @override
  List<Object> get props => [];
}

class CatListInitial extends CatListState {}

class CatListLoading extends CatListState {}

class CatListLoaded extends CatListState {
  final List<Cat> cats;
  final int currentIndex;

  const CatListLoaded({
    required this.cats,
    this.currentIndex = 0,
  });

  @override
  List<Object> get props => [cats, currentIndex];

  CatListLoaded copyWith({
    List<Cat>? cats,
    int? currentIndex,
  }) {
    return CatListLoaded(
      cats: cats ?? this.cats,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class CatListError extends CatListState {
  final String message;

  const CatListError({required this.message});

  @override
  List<Object> get props => [message];
}