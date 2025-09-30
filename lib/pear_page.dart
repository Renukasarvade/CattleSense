import 'package:flutter/material.dart';

class PearPage extends StatelessWidget {
  const PearPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1), // Soft pink
      body: Stack(
        children: [
          // 🔙 Back Arrow
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.pinkAccent, size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          // 📷 Main Content
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 100),

                  // 🖼️ Vertical Image with Pink Border
                  Container(
                    width: 240,
                    height: 360,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pinkAccent, width: 5),
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('assets/assets/pear.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // ✨ Gradient Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: [Colors.pinkAccent, Colors.purpleAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: const Text(
                        "Slim at the top, curve at the bottom — your body is poetry in motion!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Cursive',
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.purple,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

