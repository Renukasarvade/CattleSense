import 'package:flutter/material.dart';
import 'spinning_wheel_page.dart';

class ColorSelectionPage extends StatelessWidget {
  const ColorSelectionPage({super.key});

  final List<Map<String, dynamic>> baseColors = const [
    {"name": "Pink", "color": Colors.pink},
    {"name": "Red", "color": Colors.red},
    {"name": "Orange", "color": Colors.orange},
    {"name": "Yellow", "color": Colors.yellow},
    {"name": "Green", "color": Colors.green},
    {"name": "Blue", "color": Colors.blue},
    {"name": "Purple", "color": Colors.purple},
    {"name": "Brown", "color": Colors.brown},
    {"name": "Cyan", "color": Colors.cyan},
    {"name": "Lime", "color": Colors.lime},
    {"name": "Amber", "color": Colors.amber},
    {"name": "Teal", "color": Colors.teal},
    {"name": "Indigo", "color": Colors.indigo},
    {"name": "Deep Orange", "color": Colors.deepOrange},
    {"name": "Deep Purple", "color": Colors.deepPurple},
    {"name": "Light Blue", "color": Colors.lightBlue},
    {"name": "Light Green", "color": Colors.lightGreen},
    {"name": "Grey", "color": Colors.grey},
    {"name": "Blue Grey", "color": Colors.blueGrey},
    {"name": "Black", "color": Colors.black},
  ];

  // Generate 10 shades from light to dark
  List<Color> generateShades(Color baseColor) {
    return List.generate(20, (index) {
      double strength = (index + 1) * 0.1; // 0.1 to 1.0
      return Color.lerp(Colors.white, baseColor, strength)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Color Shade'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        itemCount: baseColors.length,
        itemBuilder: (context, index) {
          final colorItem = baseColors[index];
          final List<Color> shades = generateShades(colorItem['color']);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  colorItem['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: shades.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SpinningWheelPage(
                                  selectedColor: shades[i]),
                            ),
                          );
                        },
                        child: Container(
                          width: 50,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: shades[i],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                color: i < 5 ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

