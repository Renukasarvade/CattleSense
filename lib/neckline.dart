import 'package:flutter/material.dart';
import 'hs_display_page.dart';  // Import HSDisplayPage

class NecklinePage extends StatelessWidget {
  const NecklinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> necklineImages = List.generate(
      11,
          (index) => 'assets/assets/necklines/n${index + 1}.png', // 11 images
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // Soft pastel pink
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC0CB), // Light pink
        title: const Text(
          'Neckline Recommendations',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: ListView.builder(
          itemCount: necklineImages.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigate to HSDisplayPage with the corresponding hs image
                String hsImagePath = 'assets/assets/hairstyles/hs${index + 1}.jpg';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HSDisplayPage(imagePath: hsImagePath),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    necklineImages[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
