part of 'cat_list_bloc.dart';

abstract class CatListEvent extends Equatable {
  const CatListEvent();

  @override
  List<Object> get props => [];
}

class LoadRandomCats extends CatListEvent {
  final int limit;

  const LoadRandomCats({this.limit = 10});

  @override
  List<Object> get props => [limit];
}