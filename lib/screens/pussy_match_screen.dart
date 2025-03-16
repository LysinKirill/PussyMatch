import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:pussy_match/screens/cat_details_screen.dart';
import '../models/cat_model.dart';
import '../services/cat_api.dart';
import '../widgets/cat_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/heart_counter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'liked_cats_screen.dart';

class CatTinderScreen extends StatefulWidget {
  const CatTinderScreen({super.key});

  @override
  CatTinderScreenState createState() => CatTinderScreenState();
}

class CatTinderScreenState extends State<CatTinderScreen> {
  static const int bufferSize = 10;
  int _currentIndex = 0;
  late final CatApi _catApi;
  final List<Cat> _catBuffer = [];
  late final CardSwiperController _controller;
  final List<Cat> _likedCats = [];

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['CAT_API_KEY'] ?? '';
    _catApi = CatApi(apiKey);
    _preloadCats();
    _controller = CardSwiperController();
  }

  Future<void> _preloadCats() async {
    for (int i = 0; i < bufferSize; i++) {
      _fetchNewCat();
    }
  }

  Future<void> _fetchNewCat() async {
    try {
      final cat = await _catApi.fetchRandomCat();
      if (_catBuffer.length < bufferSize) {
        setState(() => _catBuffer.add(cat));
      } else {
        setState(() => _catBuffer[_currentIndex] = cat);
        _currentIndex = (_currentIndex + 1) % bufferSize;
      }
      final imageProvider = NetworkImage(cat.url);
      await precacheImage(imageProvider, context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load a new cat')));
    }
  }

  void _removeLikedCat(Cat cat) {
    setState(() {
      _likedCats.remove(cat);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
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
          Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => LikedCatsScreen(
                          likedCats: _likedCats,
                          onRemoveCat: _removeLikedCat,
                        ),
                  ),
                );
              },
              child: HeartCounter(likedCount: _likedCats.length),
            ),
          ),
        ],
      ),
      body:
          _catBuffer.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 0.8,
                        child: CardSwiper(
                          controller: _controller,
                          cardsCount: _catBuffer.length,
                          cardBuilder:
                              (context, index, _, __) => CatCard(
                                cat: _catBuffer[index],
                                onTap:
                                    () => _showDetailsModal(
                                      context,
                                      _catBuffer[index],
                                    ),
                              ),
                          onSwipe: _onSwipe,
                          onUndo: _onUndo,
                        ),
                      ),
                    ),
                  ),
                  ActionButtons(controller: _controller),
                ],
              ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    _handleSwipe(direction, previousIndex);
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    return true;
  }

  void _handleSwipe(CardSwiperDirection direction, int previousIndex) {
    if (_catBuffer.isNotEmpty) {
      final swipedCat = _catBuffer[previousIndex];
      if (direction == CardSwiperDirection.right) {
        setState(() {
          _likedCats.add(swipedCat);
        });
      }
      _fetchNewCat();
    }
  }

  void _showDetailsModal(BuildContext context, Cat cat) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CatDetailScreen(cat: cat)),
    );
  }
}
