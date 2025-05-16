import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../domain/entities/cat.dart';
import '../bloc/cat_list/cat_list_bloc.dart';
import '../bloc/liked_cats/liked_cats_bloc.dart';
import '../widgets/cat_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/heart_counter.dart';
import 'liked_cats_page.dart';

class CatListPage extends StatelessWidget {
  const CatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  CatListBloc(getCats: context.read())
                    ..add(const LoadRandomCats()),
        ),
        BlocProvider(
          create: (context) => LikedCatsBloc(
            getLikedCats: context.read(),
            likeCat: context.read(),
            unlikeCat: context.read(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'PussyMatch',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
          actions: [
            BlocBuilder<LikedCatsBloc, LikedCatsState>(
              builder: (context, state) {
                final likedCount =
                    state is LikedCatsLoaded ? state.cats.length : 0;
                return Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LikedCatsPage(),
                        ),
                      );
                    },
                    child: HeartCounter(likedCount: likedCount),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<CatListBloc, CatListState>(
          listener: (context, state) {
            if (state is CatListError) {
              _showErrorDialog(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is CatListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CatListLoaded) {
              return _buildCatSwiper(context, state.cats, state.currentIndex);
            } else if (state is CatListError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildCatSwiper(BuildContext context, List<Cat> cats, int currentIndex) {
    final controller = CardSwiperController();
    //final displayedCats = cats.sublist(currentIndex);
    final displayedCats = cats;

    return Column(
      children: [
        Expanded(
          child: CardSwiper(
            controller: controller,
            cardsCount: displayedCats.length,
            cardBuilder: (context, index, _, __) => CatCard(
              cat: displayedCats[index],
              onTap: () => _showCatDetails(context, displayedCats[index]),
            ),
            onSwipe: (prevIndex, currentIndex, direction) {
              if (direction == CardSwiperDirection.right) {
                context.read<LikedCatsBloc>().add(
                  AddLikedCat(cat: displayedCats[prevIndex]),
                );
              }
              context.read<CatListBloc>().add(const CatSwiped());
              return true;
            },
          ),
        ),
        ActionButtons(controller: controller),
      ],
    );
  }

  void _showCatDetails(BuildContext context, Cat cat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: Text(cat.breed.name)),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(cat.imageUrl),
                    Text(cat.breed.description),
                    // Add more details here
                  ],
                ),
              ),
            ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
