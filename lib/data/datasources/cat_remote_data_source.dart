import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../core/errors/exceptions.dart';
import '../dtos/cat_dto.dart';

class CatRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final String apiKey;

  CatRemoteDataSource({
    required this.client,
    required this.baseUrl,
    required this.apiKey,
  });

  Future<List<CatDto>> getRandomCats(int limit) async {
    final response = await client.get(
      Uri.parse('$baseUrl/images/search?has_breeds=true&limit=$limit'),
      headers: {'x-api-key': apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CatDto.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to load cats');
    }
  }
}