import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/cat_model.dart';
import '../screens/cat_details_screen.dart';

class LikedCatsScreen extends StatefulWidget {
  final List<Cat> likedCats;
  final Function(Cat) onRemoveCat;

  const LikedCatsScreen({
    required this.likedCats,
    required this.onRemoveCat,
    super.key,
  });

  @override
  LikedCatsScreenState createState() => LikedCatsScreenState();
}

class LikedCatsScreenState extends State<LikedCatsScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liked Cats')),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: widget.likedCats.length,
        itemBuilder: (context, index, animation) {
          final cat = widget.likedCats[index];
          return _buildListItem(cat, animation, index);
        },
      ),
    );
  }

  Widget _buildListItem(Cat cat, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(cat.url, fit: BoxFit.cover),
              ),
            ),
            title: Text(
              cat.breed.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Лайкнут: ${DateFormat('dd.MM.yyyy HH:mm').format(cat.likedTimestamp)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _removeCat(index);
              },
            ),
            onTap: () {
              // Navigate to the CatDetailScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CatDetailScreen(cat: cat),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _removeCat(int index) {
    final removedCat = widget.likedCats[index];
    widget.onRemoveCat(removedCat);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildListItem(removedCat, animation, index),
    );
  }
}
