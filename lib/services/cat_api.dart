import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cat_model.dart';

class CatApi {
  String apiKey;
  final String baseUrl = 'https://api.thecatapi.com/v1';

  CatApi(this.apiKey);

  Future<Cat> fetchRandomCat() async {
    final response = await http.get(
      Uri.parse('$baseUrl/images/search?has_breeds=true'),
      headers: {'x-api-key': apiKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty && data[0]['breeds'] != null && data[0]['breeds'].isNotEmpty) {
        return Cat.fromJson(data[0]);
      } else {
        throw Exception('No breed information found');
      }
    } else {
      throw Exception('Failed to load cat');
    }
  }
}