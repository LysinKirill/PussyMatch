import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../data/datasources/cat_remote_data_source.dart';
import '../../data/repositories/cat_repository_impl.dart';
import '../../domain/repositories/cat_repository.dart';
import '../../domain/usecases/get_cats.dart';
import '../../domain/usecases/get_liked_cats.dart';
import '../../domain/usecases/like_cat.dart';
import '../../domain/usecases/unlike_cat.dart';
import '../presentation/bloc/cat_list/cat_list_bloc.dart';
import '../presentation/bloc/liked_cats/liked_cats_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  await dotenv.load(fileName: ".env");
  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton(() => GetCats(repository: sl()));
  sl.registerLazySingleton(() => GetLikedCats(repository: sl()));
  sl.registerLazySingleton(() => LikeCat(repository: sl()));
  sl.registerLazySingleton(() => UnlikeCat(repository: sl()));

  //! Data Sources
  sl.registerLazySingleton<CatRemoteDataSource>(
        () => CatRemoteDataSource(
      client: sl(),
      baseUrl: 'https://api.thecatapi.com/v1',
      apiKey: dotenv.env['CAT_API_KEY']!,
    ),
  );

  //! Repositories
  sl.registerLazySingleton<CatRepository>(
        () => CatRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  //! Use Cases


  //! Blocs
  sl.registerFactory(
        () => CatListBloc(
      getCats: sl(),
    ),
  );
  sl.registerSingleton<LikedCatsBloc>(
    LikedCatsBloc(
      getLikedCats: sl(),
      likeCat: sl(),
      unlikeCat: sl(),
    ),
  );
}