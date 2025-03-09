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

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['CAT_API_KEY'] ?? ''; // Get API key from .env
    _catApi = CatApi(apiKey);
    _fetchNewCat();
  }

  Map<String, dynamic>? _currentCat;

  Future<void> _fetchNewCat() async {
    try {
      final cat = await _catApi.fetchRandomCat();
      setState(() {
        _currentCat = cat;
      });
    } catch (e) {
      print('Error fetching cat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load a new cat. Please try again.')),
      );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(_currentCat!['url']),
            if (_currentCat!['breeds'] != null && _currentCat!['breeds'].isNotEmpty)
              Text(_currentCat!['breeds'][0]['name'])
            else
              Text('Unknown Breed'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_down),
                  onPressed: () => _fetchNewCat(),
                ),
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: () => _fetchNewCat(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}