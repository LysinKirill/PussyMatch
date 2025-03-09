import 'package:http/http.dart' as http;
import 'dart:convert';

class CatApi {
  String apiKey;
  final String baseUrl = 'https://api.thecatapi.com/v1';

  CatApi(this.apiKey);

  Future<Map<String, dynamic>> fetchRandomCat() async {
    final response = await http.get(
      Uri.parse('$baseUrl/images/search?has_breeds=true'),
      headers: {'x-api-key': apiKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data); // Log the API response
      if (data.isNotEmpty && data[0]['breeds'] != null && data[0]['breeds'].isNotEmpty) {
        return data[0];
      } else {
        throw Exception('No breed information found');
      }
    } else {
      throw Exception('Failed to load cat');
    }
  }
}