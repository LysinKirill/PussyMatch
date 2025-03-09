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

    print("\n\n\n\n");
    print('$baseUrl/images/search?has_breeds=true');
    print("\n\n\n\n");
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)[0];
    } else {
      throw Exception('Failed to load cat');
    }
  }
}