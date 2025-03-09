import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'services/cat_api.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кототиндер',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CatTinderScreen(),
    );
  }
}

class CatTinderScreen extends StatefulWidget {
  @override
  _CatTinderScreenState createState() => _CatTinderScreenState();
}

class _CatTinderScreenState extends State<CatTinderScreen> {
  static const int bufferSize = 10; // Fixed buffer size
  int _currentIndex = 0; // Tracks current position in buffer
  List<Map<String, dynamic>?> _catBuffer = List.filled(bufferSize, null); // Fixed-size buffer

  int _likedCount = 0;
  late final CatApi _catApi;
  final List<Map<String, dynamic>> _catQueue = [];
  final CardSwiperController _controller = CardSwiperController();
  double _swipeProgress = 0.0;

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['CAT_API_KEY'] ?? '';
    _catApi = CatApi(apiKey);
    _preloadCats();
  }

  Future<void> _preloadCats() async {
    // Fill all buffer slots with cats
    for (int i = 0; i < bufferSize; i++) {
      await _fetchNewCat();
    }
  }
  

  Future<void> _fetchNewCat() async {
    try {
      final cat = await _catApi.fetchRandomCat();
      setState(() => _catQueue.add(cat));
      final imageProvider = NetworkImage(cat['url']);
      await precacheImage(imageProvider, context);

      if (_catQueue.length < preloadCatsCount) {
        _fetchNewCat();
      }
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
        title: Text('PussyMatch'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: _buildHeartCounter(),
          ),
        ],
      ),
      body: _catQueue.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Flexible(
            child: Stack(
              children: [
                CardSwiper(
                  controller: _controller,
                  cardsCount: _catQueue.length,
                  cardBuilder: (context, index, percentThresholdX, percentThresholdY) => _buildCard(context, index, percentThresholdX, percentThresholdY),
                  onSwipe: _onSwipe,
                  onUndo: _onUndo,
                  //onUpdate: _onUpdate,
                ),
                _buildSwipeFeedback(),
              ],
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildCard(
      BuildContext context,
      int index,
      int horizontalThresholdPercentage,
      int verticalThresholdPercentage,
      ) {
    final cat = _catQueue[index];
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showDetailsModal(context, cat),
            child: Image.network(
              cat['url'],
              fit: BoxFit.cover,
              height: 300,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              cat['breeds'][0]['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeFeedback() {
    if (_swipeProgress == 0) return SizedBox.shrink();

    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                _swipeProgress > 0
                    ? Colors.green.withOpacity(_swipeProgress.abs() * 0.5)
                    : Colors.red.withOpacity(_swipeProgress.abs() * 0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.thumb_down, size: 40, color: Colors.red),
            onPressed: () => _controller.swipe(CardSwiperDirection.left),
          ),
          SizedBox(width: 40),
          IconButton(
            icon: Icon(Icons.thumb_up, size: 40, color: Colors.green),
            onPressed: () => _controller.swipe(CardSwiperDirection.right),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartCounter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.favorite, color: Colors.red),
          SizedBox(width: 8),
          Text(
            '$_likedCount',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }

  bool _onSwipe(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
      ) {
    setState(() => _swipeProgress = 0);
    _handleSwipe(direction);
    return true;
  }

  bool _onUndo(int? previousIndex, int currentIndex, CardSwiperDirection direction) {
    return true;
  }

  void _onUpdate(double progress, CardSwiperDirection direction) {
    setState(() => _swipeProgress = progress);
  }

  void _handleSwipe(CardSwiperDirection direction) {
    if (_catQueue.isNotEmpty) {
      setState(() {
        // Remove swiped cat
        _catQueue.removeAt(0);

        // Update liked count
        if (direction == CardSwiperDirection.right) {
          _likedCount++;
        }
      });
      // Trigger new fetch if queue gets low
      if (_catQueue.length < preloadCatsCount) {
        _fetchNewCat();
      }
    }
  }

  void _showDetailsModal(BuildContext context, Map<String, dynamic> cat) {
    // Your existing modal code
  }
}