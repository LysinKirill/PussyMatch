import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../core/errors/exceptions.dart';
import '../dtos/cat_dto.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CatRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final String apiKey;
  final DefaultCacheManager cacheManager;

  CatRemoteDataSource({
    required this.client,
    required this.baseUrl,
    required this.apiKey,
    required this.cacheManager,
  });

  Future<List<CatDto>> getRandomCats(int limit) async {
    final response = await client.get(
      Uri.parse('$baseUrl/images/search?has_breeds=true&limit=$limit'),
      headers: {'x-api-key': apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final cats = data.map((json) => CatDto.fromJson(json)).toList();
      await Future.wait(cats.map((cat) => _precacheImage(cat.url)));
      return cats;
    } else {
      throw ServerException(message: 'Failed to load cats');
    }
  }

  Future<void> _precacheImage(String url) async {
    try {
      await cacheManager.getSingleFile(url);
    } catch (e) {
      debugPrint('Failed to precache image: $e');
    }
  }
}
