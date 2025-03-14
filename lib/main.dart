import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:url_launcher/url_launcher.dart';
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
  static const int bufferSize = 10;
  int _currentIndex = 0;
  int _likedCount = 0;
  late final CatApi _catApi;
  final List<Map<String, dynamic>> _catQueue = [];
  late final CardSwiperController _controller;

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['CAT_API_KEY'] ?? '';
    _catApi = CatApi(apiKey);
    _preloadCats();
    _controller =  CardSwiperController();
  }

  Future<void> _preloadCats() async {
    for (int i = 0; i < bufferSize; i++) {
      _fetchNewCat();
    }
  }
  

  Future<void> _fetchNewCat() async {
    try {
      final cat = await _catApi.fetchRandomCat();
      if(_catQueue.length < bufferSize) {
        setState(() => _catQueue.add(cat));
      }
      else {
        setState(() => _catQueue[_currentIndex] = cat);
        _currentIndex = (_currentIndex + 1) % bufferSize;
      }
      final imageProvider = NetworkImage(cat['url']);
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
            color: Colors.white, // Title background color
            borderRadius: BorderRadius.circular(20), // Rounded corners
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
              color: Colors.blue[800], // Title text color
            ),
          ),
        ),
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
                          _buildCard(context, index, percentThresholdX, percentThresholdY),
                      onSwipe: _onSwipe,
                      onUndo: _onUndo,
                    )
                  ],
                ),
              ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onTap: () => _showDetailsModal(context, cat),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child:
                GestureDetector(
                  onTap: () => _showDetailsModal(context, cat),
                  child: Image.network(
                    cat['url'],
                    fit: BoxFit.cover,
                    height: 300,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text(
              cat['breeds'][0]['name'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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

  void _showDetailsModal(BuildContext context, Map<String, dynamic> cat) {
    final breed = cat['breeds'][0];
    final mediaQuery = MediaQuery.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: mediaQuery.viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[700]),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Text(
                breed['name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 16),
              // Cat Image
              AspectRatio(aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      cat['url'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  )
              )
              ,
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailCard('Description', breed['description']),
                      _buildDetailCard('Temperament', breed['temperament']),
                      _buildDetailCard('Origin', breed['origin']),
                      _buildDetailCard('Life Span', '${breed['life_span']} years'),
                      _buildDetailCard('Weight', '${breed['weight']['metric']} kg'),
                      _buildDetailCard('Adaptability', '${breed['adaptability']}/5'),
                      _buildDetailCard('Affection Level', '${breed['affection_level']}/5'),
                      _buildDetailCard('Child Friendly', '${breed['child_friendly']}/5'),
                      _buildDetailCard('Dog Friendly', '${breed['dog_friendly']}/5'),
                      _buildDetailCard('Energy Level', '${breed['energy_level']}/5'),
                      _buildDetailCard('Health Issues', '${breed['health_issues']}/5'),
                      _buildDetailCard('Intelligence', '${breed['intelligence']}/5'),
                      _buildDetailCard('Social Needs', '${breed['social_needs']}/5'),
                      _buildDetailCard('Stranger Friendly', '${breed['stranger_friendly']}/5'),
                      _buildDetailCard('Vocalisation', '${breed['vocalisation']}/5'),
                      ElevatedButton(
                        onPressed: () {
                          if (breed['wikipedia_url'] != null) {
                            launchUrl(Uri.parse(breed['wikipedia_url']));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Open Wikipedia',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}