import 'package:flutter/material.dart';

class DressRecommendationPage extends StatelessWidget {
  final String occasion;

  const DressRecommendationPage({super.key, required this.occasion});

  // Map of occasion to dummy image paths (replace with real assets or URLs)
  Map<String, List<String>> get occasionImages => {
    'Wedding': [
      'assets/assets/wedding/wedding1.jpg',
      'assets/assets/wedding/wedding2.jpg',
      'assets/assets/wedding/wedding3.jpg',
      'assets/assets/wedding/wedding4.jpg',
    ],
    'Birthday': [
      'assets/assets/birthday/birthday1.jpg',
      'assets/assets/birthday/birthday2.jpg',
      'assets/assets/birthday/birthday3.jpg',
      'assets/assets/birthday/birthday4.jpg',
    ],
    'Date Night': [
      'assets/assets/dn/dn1.jpg',
      'assets/assets/dn/dn2.jpg',
      'assets/assets/dn/dn3.jpg',
      'assets/assets/dn/dn4.jpg',
    ],
    'Girls Night': [
      'assets/assets/dn/d1.jpg',
      'assets/assets/dn/d2.jpg',
      'assets/assets/dn/d3.jpg',
      'assets/assets/dn/d4.jpg',
    ],
    'Office': [
      'assets/assets/office/b1.jpg',
      'assets/assets/office/b2.jpg',
      'assets/assets/office/b3.jpg',
      'assets/assets/office/b4.jpg',
    ],
    'Beach Party': [
      'assets/assets/bp/bp1.jpg',
      'assets/assets/bp/bp2.jpg',
      'assets/assets/bp/bp3.jpg',
      'assets/assets/bp/bp4.jpg',
    ],
    'Brunch': [
      'assets/assets/office/b1.jpg',
      'assets/assets/office/b2.jpg',
      'assets/assets/office/b3.jpg',
      'assets/assets/office/b4.jpg',
    ],
    'Festive': [
      'assets/assets/bp/f1.jpg',
      'assets/assets/bp/f2.jpg',
      'assets/assets/bp/f3.jpg',
      'assets/assets/bp/f4.jpg',
    ],
    'Formal': [
      'assets/assets/bp/fm1.jpg',
      'assets/assets/bp/fm2.jpg',
      'assets/assets/bp/fm3.jpg',
      'assets/assets/bp/fm4.jpg',
    ],
    'Casual': [
      'assets/assets/bp/casual1.jpg',
      'assets/assets/bp/casual2.jpg',
      'assets/assets/bp/casual3.jpg',
      'assets/assets/bp/casual4.jpg',
    ],
    // Add entries for all other occasions...
  };

  @override
  Widget build(BuildContext context) {
    final images = occasionImages[occasion] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Outfits for $occasion"),
        backgroundColor: Colors.pinkAccent,
      ),
      backgroundColor: const Color(0xFFFFF0F5),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: images.isEmpty
            ? Center(child: Text("No images found for $occasion"))
            : GridView.builder(
          itemCount: images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
