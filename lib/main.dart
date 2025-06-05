import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:pussy_match/presentation/bloc/cat_list/cat_list_bloc.dart';
import 'package:pussy_match/presentation/bloc/liked_cats/liked_cats_bloc.dart';
import 'package:pussy_match/presentation/pages/cat_list_page.dart';

import 'core/injection_container.dart';
import 'core/network/network_bloc.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await init();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.instance<NetworkBloc>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<CatListBloc>()
            ..add(const LoadRandomCats(limit: 10)),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<LikedCatsBloc>()
            ..add(LoadLikedCats()),
        ),
      ],
      child: MaterialApp(
        title: 'PussyMatch',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: const CatListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}