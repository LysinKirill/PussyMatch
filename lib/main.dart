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
                    onPressed: () => _fetchNewCat(),
                  ),
                  IconButton(
                    icon: Icon(Icons.thumb_up, color: Colors.green),
                    onPressed: () => _fetchNewCat(),
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