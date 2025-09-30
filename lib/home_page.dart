import 'package:flutter/material.dart';
import 'outfit_classifier_page.dart';
import 'color_theory_page.dart';
import 'body_shape_page.dart';
import 'neckline.dart';
import 'fashion_quiz_page.dart';
import 'color_selection_page.dart';
import 'virtual_try_on_page.dart';
import 'find_the_dress.dart'; // ✅ NEW import

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _centerImageIndex = 0;

  final List<String> centerImages = [
    'assets/assets/home_center1.jpeg',
    'assets/assets/home_center2.jpeg',
  ];

  void _onMenuSelected(BuildContext context, String value) {
    switch (value) {
      case 'Virtual Try-On':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VirtualTryOnPage()),
        );
        break;
      case 'Balance Your Outfit':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ColorSelectionPage()),
        );
        break;
      case 'Outfit Classifier':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OutfitClassifierPage()),
        );
        break;
      case 'Find Your Body Shape':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BodyShapePage()),
        );
        break;
      case 'Neckline Recommendation':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NecklinePage()),
        );
        break;
      case 'Fashion Quiz Game':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FashionQuizPage()),
        );
        break;
      case 'Color Theory':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ColorTheoryPage()),
        );
        break;
      case 'Find The Dress': // ✅ NEW menu case
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FindTheDressPage()),
        );
        break;
    }
  }

  void _toggleCenterImage() {
    setState(() {
      _centerImageIndex = (_centerImageIndex + 1) % centerImages.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _toggleCenterImage,
        child: Stack(
          children: [
            // 🔹 Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/assets/home_bg.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 🔹 Overlay Content
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // 🔹 Top Menu Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            cardColor: const Color(0xFFFFE4E1),
                          ),
                          child: PopupMenuButton<String>(
                            icon: const Icon(Icons.menu, color: Colors.black, size: 30),
                            onSelected: (value) => _onMenuSelected(context, value),
                            itemBuilder: (BuildContext context) => const [
                              PopupMenuItem(
                                value: 'Virtual Try-On',
                                child: Text('Virtual Try-On'),
                              ),
                              PopupMenuItem(
                                value: 'Balance Your Outfit',
                                child: Text('Balance Your Outfit'),
                              ),
                              PopupMenuItem(
                                value: 'Outfit Classifier',
                                child: Text('Outfit Classifier'),
                              ),
                              PopupMenuItem(
                                value: 'Find Your Body Shape',
                                child: Text('Find Your Body Shape'),
                              ),
                              PopupMenuItem(
                                value: 'Neckline Recommendation',
                                child: Text('Neckline Recommendation'),
                              ),
                              PopupMenuItem(
                                value: 'Fashion Quiz Game',
                                child: Text('Fashion Quiz Game'),
                              ),
                              PopupMenuItem(
                                value: 'Color Theory',
                                child: Text('Color Theory'),
                              ),
                              PopupMenuItem( // ✅ NEW option
                                value: 'Find The Dress',
                                child: Text('Find The Dress'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Text(
                          'OWN YOUR STYLE!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 🔹 Center Image & Tagline (Centered Properly)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(seconds: 2),
                          child: Image.asset(
                            centerImages[_centerImageIndex],
                            key: ValueKey<int>(_centerImageIndex),
                            height: 300,
                            width: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Unleash Your Inner Fashionista',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFE4E1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
