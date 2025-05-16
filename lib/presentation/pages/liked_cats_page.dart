import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/cat.dart';
import '../bloc/liked_cats/liked_cats_bloc.dart';
import '../widgets/filter_dropdown.dart';

class LikedCatsPage extends StatelessWidget {
  const LikedCatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<LikedCatsBloc>(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Liked Cats'),
          actions: [
            BlocBuilder<LikedCatsBloc, LikedCatsState>(
              builder: (context, state) {
                return FilterDropdown(
                  onBreedSelected: (breedId) {
                    context.read<LikedCatsBloc>().add(
                      FilterLikedCatsByBreed(breedId: breedId),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<LikedCatsBloc, LikedCatsState>(
          builder: (context, state) {
            if (state is LikedCatsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LikedCatsLoaded) {
              return _buildCatList(context, state.cats);
            } else if (state is LikedCatsError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildCatList(BuildContext context, List<Cat> cats) {
    if (cats.isEmpty) {
      return const Center(child: Text('No liked cats yet'));
    }

    return ListView.builder(
      itemCount: cats.length,
      itemBuilder: (context, index) {
        final cat = cats[index];
        return Dismissible(
          key: Key(cat.id),
          background: Container(color: Colors.red),
          onDismissed: (direction) {
            context.read<LikedCatsBloc>().add(RemoveLikedCat(catId: cat.id));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${cat.breed.name} removed')),
            );
          },
          child: ListTile(
            leading: Image.network(
              cat.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text(cat.breed.name),
            subtitle: Text(
              DateFormat('dd.MM.yyyy HH:mm').format(cat.likedTimestamp),
            ),
            onTap: () => _showCatDetails(context, cat),
          ),
        );
      },
    );
  }

  void _showCatDetails(BuildContext context, Cat cat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
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
}