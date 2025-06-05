part of 'liked_cats_bloc.dart';

abstract class LikedCatsState extends Equatable {
  const LikedCatsState();

  @override
  List<Object> get props => [];
}

class LikedCatsInitial extends LikedCatsState {}

class LikedCatsLoading extends LikedCatsState {}

class LikedCatsLoaded extends LikedCatsState {
  final List<Cat> cats;
  final String? filteredBreedId;

  const LikedCatsLoaded({required this.cats, this.filteredBreedId});

  @override
  List<Object> get props => [cats, filteredBreedId ?? ''];
}

class LikedCatsError extends LikedCatsState {
  final String message;

  const LikedCatsError({required this.message});

  @override
  List<Object> get props => [message];
}
