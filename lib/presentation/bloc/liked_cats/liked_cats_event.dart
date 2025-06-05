part of 'liked_cats_bloc.dart';

abstract class LikedCatsEvent extends Equatable {
  const LikedCatsEvent();

  @override
  List<Object> get props => [];
}

class LoadLikedCats extends LikedCatsEvent {}

class AddLikedCat extends LikedCatsEvent {
  final Cat cat;

  const AddLikedCat({required this.cat});

  @override
  List<Object> get props => [cat];
}

class RemoveLikedCat extends LikedCatsEvent {
  final String catId;

  const RemoveLikedCat({required this.catId});

  @override
  List<Object> get props => [catId];
}

class FilterLikedCatsByBreed extends LikedCatsEvent {
  final String? breedId;

  const FilterLikedCatsByBreed({this.breedId});

  @override
  List<Object> get props => [breedId ?? ''];
}
