import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CatTinderScreen(),
    );
  }
}

class CatTinderScreen extends StatefulWidget {
  @override
  _CatTinderScreenState createState() => _CatTinderScreenState();
}

class _CatTinderScreenState extends State<CatTinderScreen> {
  late final CatApi _catApi;
  final List<Map<String, dynamic>> _catQueue = []; // Queue of preloaded cats
  Map<String, dynamic>? _currentCat;

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['CAT_API_KEY'] ?? '';
    _catApi = CatApi(apiKey);
    _preloadCats(); // Preload 5 cats when the app starts
  }

  // Preload 5 cats into the queue
  Future<void> _preloadCats() async {
    for (int i = 0; i < 5; i++) {
      await _fetchNewCat();
    }
    _showNextCat(); // Show the first cat
  }

  // Fetch a new cat and add it to the queue
  Future<void> _fetchNewCat() async {
    try {
      final cat = await _catApi.fetchRandomCat();
      setState(() {
        _catQueue.add(cat); // Add the new cat to the queue
      });
      // Preload the image into memory
      final imageUrl = cat['url'];
      final imageProvider = NetworkImage(imageUrl);
      await precacheImage(imageProvider, context);
    } catch (e) {
      print('Error fetching cat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load a new cat. Please try again.')),
      );
    }
  }

  // Show the next cat from the queue
  void _showNextCat() {
    if (_catQueue.isNotEmpty) {
      setState(() {
        _currentCat = _catQueue.removeAt(0); // Remove the first cat from the queue
      });
      _fetchNewCat(); // Fetch a new cat to keep the queue full
    } else {
      setState(() {
        _currentCat = null; // No cats left in the queue
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Кототиндер'),
      ),
      body: _currentCat == null
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: Card(
          elevation: 5,
          margin: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _showDetailsModal(context, _currentCat!),
                child: Image.network(
                  _currentCat!['url'],
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  _currentCat!['breeds'][0]['name'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_down, color: Colors.red),
                    onPressed: () => _showNextCat(),
                  ),
                  IconButton(
                    icon: Icon(Icons.thumb_up, color: Colors.green),
                    onPressed: () => _showNextCat(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsModal(BuildContext context, Map<String, dynamic> cat) {
    final breed = cat['breeds'][0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                breed['name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Image.network(cat['url'], fit: BoxFit.cover),
              SizedBox(height: 16),
              Text(
                'Description: ${breed['description']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}