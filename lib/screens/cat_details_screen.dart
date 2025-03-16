import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cat_model.dart';

class CatDetailScreen extends StatelessWidget {
  final Cat cat;

  const CatDetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    final breed = cat.breed;

    return Scaffold(
      appBar: AppBar(title: Text(breed.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    cat.url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildDetailCard('Description', breed.description),
              const SizedBox(height: 16),
              _buildDetailCard('Temperament', breed.temperament),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailCard(
                      'Life Span',
                      '${breed.lifeSpan} years',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDetailCard(
                      'Weight',
                      '${breed.weight['metric']} kg',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCategoryTag('Adaptability', breed.adaptability),
                  _buildCategoryTag('Affection Level', breed.affectionLevel),
                  _buildCategoryTag('Child Friendly', breed.childFriendly),
                  _buildCategoryTag('Dog Friendly', breed.dogFriendly),
                  _buildCategoryTag('Energy Level', breed.energyLevel),
                  _buildCategoryTag('Health Issues', breed.healthIssues),
                  _buildCategoryTag('Intelligence', breed.intelligence),
                  _buildCategoryTag('Social Needs', breed.socialNeeds),
                  _buildCategoryTag(
                    'Stranger Friendly',
                    breed.strangerFriendly,
                  ),
                  _buildCategoryTag('Vocalisation', breed.vocalisation),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (breed.wikipediaUrl.isNotEmpty) {
                      launchUrl(Uri.parse(breed.wikipediaUrl));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Open Wikipedia',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTag(String category, int score) {
    final tag = _getTagForCategory(category, score);
    if (category == "Health Issues") {
      score = 6 - score;
    }

    final color = _getColorForScore(score);
    final textColor = _getTextColorForScore(score);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withValues(alpha: 0.15),
          width: 1.5,
        ),
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 1), color.withValues(alpha: 0)],
          begin: Alignment.center,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  String _getTagForCategory(String category, int score) {
    switch (category) {
      case 'Adaptability':
        return [
          'Struggles to Adapt',
          'Needs Help Adapting',
          'Adaptable',
          'Flexible in Changes',
          'Highly Adaptable',
        ][score - 1];
      case 'Affection Level':
        return [
          'Aloof and Distant',
          'Reserved Affection',
          'Affectionate',
          'Loving and Warm',
          'Very Loving',
        ][score - 1];
      case 'Child Friendly':
        return [
          'Not Kid-Friendly',
          'Cautious with Kids',
          'Tolerant with Kids',
          'Kid-Friendly',
          'Very Kid-Friendly',
        ][score - 1];
      case 'Dog Friendly':
        return [
          'Not Dog-Friendly',
          'Wary of Dogs',
          'Tolerant with Dogs',
          'Dog-Friendly',
          'Very Dog-Friendly',
        ][score - 1];
      case 'Energy Level':
        return [
          'Lazy and Calm',
          'Low Energy',
          'Moderate Energy',
          'Energetic',
          'Very Energetic',
        ][score - 1];
      case 'Health Issues':
        return [
          'Very Healthy',
          'Generally Healthy',
          'Moderate Health Issues',
          'Prone to Health Issues',
          'High Maintenance Health',
        ][score - 1];
      case 'Intelligence':
        return [
          'Slow Learner',
          'Average Intelligence',
          'Smart',
          'Very Smart',
          'Highly Intelligent',
        ][score - 1];
      case 'Social Needs':
        return [
          'Independent',
          'Low Social Needs',
          'Moderate Social Needs',
          'Social and Friendly',
          'Very Social',
        ][score - 1];
      case 'Stranger Friendly':
        return [
          'Shy with Strangers',
          'Reserved with Strangers',
          'Friendly with Strangers',
          'Very Friendly with Strangers',
          'Extroverted with Strangers',
        ][score - 1];
      case 'Vocalisation':
        return [
          'Quiet',
          'Rarely Vocal',
          'Moderately Vocal',
          'Talkative',
          'Very Vocal',
        ][score - 1];
      default:
        return '';
    }
  }

  Color _getColorForScore(int score) {
    switch (score) {
      case 1:
        return const Color(0xFFFFCDD2);
      case 2:
        return const Color(0xFFFFE0B2);
      case 3:
        return const Color(0xFFFFF9C4);
      case 4:
        return const Color(0xFFC8E6C9);
      case 5:
        return const Color(0xFFB2DFDB);
      default:
        return Colors.grey;
    }
  }

  Color _getTextColorForScore(int score) {
    switch (score) {
      case 1:
        return const Color(0xFFC62828);
      case 2:
        return const Color(0xFFEF6C00);
      case 3:
        return const Color(0xFFF9A825);
      case 4:
        return const Color(0xFF2E7D32);
      case 5:
        return const Color(0xFF00695C);
      default:
        return Colors.black;
    }
  }
}
