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
                if (state is! LikedCatsLoaded) return const SizedBox();
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
        body: BlocConsumer<LikedCatsBloc, LikedCatsState>(
          listener: (context, state) {
            if (state is LikedCatsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
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
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm'),
                content: Text('Remove ${cat.breed.name} from favorites?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Remove'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            context.read<LikedCatsBloc>().add(RemoveLikedCat(catId: cat.id));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Removed ${cat.breed.name}')
              ),
            );
          },
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                cat.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.error),
              ),
            ),
            title: Text(cat.breed.name),
            subtitle: Text(
              DateFormat('dd.MM.yyyy HH:mm').format(cat.likedTimestamp),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _confirmDelete(context, cat);
              },
            ),
            onTap: () => _showCatDetails(context, cat),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Cat cat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Cat'),
        content: Text('Remove ${cat.breed.name} from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<LikedCatsBloc>().add(RemoveLikedCat(catId: cat.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed ${cat.breed.name}'),
                ),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCatDetails(BuildContext context, Cat cat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(cat.breed.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, cat),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(cat.imageUrl),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    cat.breed.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}