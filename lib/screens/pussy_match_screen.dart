import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../models/cat_model.dart';
import '../services/cat_api.dart';
import '../widgets/cat_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/heart_counter.dart';
import '../widgets/detail_modal.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CatTinderScreen extends StatefulWidget {
  @override
  _CatTinderScreenState createState() => _CatTinderScreenState();
}

class _CatTinderScreenState extends State<CatTinderScreen> {
  static const int bufferSize = 10;
  int _currentIndex = 0;
  int _likedCount = 0;
  late final CatApi _catApi;
  final List<Cat> _catQueue = [];
  late final CardSwiperController _controller;

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['CAT_API_KEY'] ?? ''; // Replace with your API key
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
      if (_catQueue.length < bufferSize) {
        setState(() => _catQueue.add(cat));
      } else {
        setState(() => _catQueue[_currentIndex] = cat);
        _currentIndex = (_currentIndex + 1) % bufferSize;
      }
      final imageProvider = NetworkImage(cat.url);
      await precacheImage(imageProvider, context);
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load a new cat')),
      );
    }
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
            )],
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
            child: HeartCounter(likedCount: _likedCount),
          ),
        ],
      ),
      body: _catQueue.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 0.8,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CardSwiper(
                      controller: _controller,
                      cardsCount: _catQueue.length,
                      cardBuilder: (context, index, percentThresholdX, percentThresholdY) =>
                          CatCard(cat: _catQueue[index], onTap: () => _showDetailsModal(context, _catQueue[index])),
                      onSwipe: _onSwipe,
                      onUndo: _onUndo,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ActionButtons(controller: _controller),
        ],
      ),
    );
  }

  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    _handleSwipe(direction);
    return true;
  }

  bool _onUndo(int? previousIndex, int currentIndex, CardSwiperDirection direction) {
    return true;
  }

  void _handleSwipe(CardSwiperDirection direction) {
    if (_catQueue.isNotEmpty) {
      setState(() {
        if (direction == CardSwiperDirection.right) {
          _likedCount++;
        }
      });

      _fetchNewCat();
    }
  }

  void _showDetailsModal(BuildContext context, Cat cat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailModal(cat: cat),
    );
  }
}