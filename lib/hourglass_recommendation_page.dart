import 'package:flutter/material.dart';

class HourglassRecommendationPage extends StatelessWidget {
  const HourglassRecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final outfitImages = [
      'assets/assets/h1.jpg',
      'assets/assets/h2.jpg',
      'assets/assets/h3.jpg',
      'assets/assets/h4.jpg',
      'assets/assets/h5.jpg',
      'assets/assets/h6.jpg',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA), // soft lavender
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        elevation: 0,
        title: const Text(
          "Outfits for You",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 16,
              children: outfitImages.map((image) {
                return Container(
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.pinkAccent.shade100,
                      width: 3,
                    ),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            const Text(
              "✔️ Do's for Hourglass Shape:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            const SizedBox(height: 8),
            const Text("• Highlight the waist with belts, fitted dresses."),
            const Text("• Choose wrap dresses, bodycon styles, pencil skirts."),
            const Text("• Opt for high-waisted pants or jeans."),
            const Text("• Use structured jackets to define shape."),

            const SizedBox(height: 20),
            const Text(
              "❌ Don'ts for Hourglass Shape:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            const SizedBox(height: 8),
            const Text("• Avoid baggy or boxy clothes that hide the waist."),
            const Text("• Skip straight-cut or shapeless dresses."),
            const Text("• Avoid heavy embellishments on shoulders/hips."),
            const Text("• Don't wear clothes with no structure."),

            const SizedBox(height: 20),
            const Text(
              "👗 Recommended Outfit Types:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 8),
            const Text("• Wrap dresses and peplum tops"),
            const Text("• Fitted blazers and pencil skirts"),
            const Text("• Mermaid cut gowns and belted coats"),
            const Text("• Tailored jumpsuits with waist definition"),
          ],
        ),
      ),
    );
  }
}
