import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pussy_match/presentation/bloc/cat_list/cat_list_bloc.dart';
import 'package:pussy_match/presentation/bloc/liked_cats/liked_cats_bloc.dart';

import 'presentation/pages/cat_list_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.instance<CatListBloc>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<LikedCatsBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'PussyMatch',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const CatListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}