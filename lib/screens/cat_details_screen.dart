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
              // Cat Image
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
              _buildDetailCard('Temperament', breed.temperament),
              _buildDetailCard('Origin', breed.origin),
              _buildDetailCard('Life Span', '${breed.lifeSpan} years'),
              _buildDetailCard('Weight', '${breed.weight['metric']} kg'),
              _buildDetailCard('Adaptability', '${breed.adaptability}/5'),
              _buildDetailCard('Affection Level', '${breed.affectionLevel}/5'),
              _buildDetailCard('Child Friendly', '${breed.childFriendly}/5'),
              _buildDetailCard('Dog Friendly', '${breed.dogFriendly}/5'),
              _buildDetailCard('Energy Level', '${breed.energyLevel}/5'),
              _buildDetailCard('Health Issues', '${breed.healthIssues}/5'),
              _buildDetailCard('Intelligence', '${breed.intelligence}/5'),
              _buildDetailCard('Social Needs', '${breed.socialNeeds}/5'),
              _buildDetailCard(
                'Stranger Friendly',
                '${breed.strangerFriendly}/5',
              ),
              _buildDetailCard('Vocalisation', '${breed.vocalisation}/5'),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
