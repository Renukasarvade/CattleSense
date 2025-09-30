import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dress_recommendation_page.dart'; // <-- Make sure this path is correct

class FindTheDressPage extends StatefulWidget {
  const FindTheDressPage({super.key});

  @override
  State<FindTheDressPage> createState() => _FindTheDressPageState();
}

class _FindTheDressPageState extends State<FindTheDressPage> with SingleTickerProviderStateMixin {
  final List<String> occasions = [
    'Wedding',
    'Birthday',
    'Date Night',
    'Office',
    'Beach Party',
    'Festive',
    'Casual',
    'Formal',
    'Brunch',
    'Girls Night',
  ];

  final List<_Bubble> _bubbles = [];
  late Ticker _ticker;
  final double _bubbleRadius = 50;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final colors = _getPastelColors();
      for (int i = 0; i < occasions.length; i++) {
        _bubbles.add(_Bubble(
          label: occasions[i],
          x: _random.nextDouble() * (size.width - 2 * _bubbleRadius),
          y: _random.nextDouble() * (size.height - 2 * _bubbleRadius),
          dx: (_random.nextDouble() - 0.5) * 2,
          dy: (_random.nextDouble() - 0.5) * 2,
          radius: _bubbleRadius,
          color: colors[i % colors.length],
        ));
      }
    });

    _ticker = createTicker((Duration _) {
      setState(() {
        _updateBubbles();
      });
    });
    _ticker.start();
  }

  void _updateBubbles() {
    final Size screenSize = MediaQuery.of(context).size;

    for (var bubble in _bubbles) {
      bubble.x += bubble.dx;
      bubble.y += bubble.dy;

      if (bubble.x < 0) {
        bubble.x = 0;
        bubble.dx = -bubble.dx;
      } else if (bubble.x > screenSize.width - bubble.radius * 2) {
        bubble.x = screenSize.width - bubble.radius * 2;
        bubble.dx = -bubble.dx;
      }
      if (bubble.y < 0) {
        bubble.y = 0;
        bubble.dy = -bubble.dy;
      } else if (bubble.y > screenSize.height - bubble.radius * 2) {
        bubble.y = screenSize.height - bubble.radius * 2;
        bubble.dy = -bubble.dy;
      }

      final speed = sqrt(bubble.dx * bubble.dx + bubble.dy * bubble.dy);
      const minSpeed = 0.5;
      if (speed < minSpeed && speed > 0) {
        final factor = minSpeed / speed;
        bubble.dx *= factor;
        bubble.dy *= factor;
      }
    }

    final colors = _getPastelColors();
    for (int i = 0; i < _bubbles.length; i++) {
      for (int j = i + 1; j < _bubbles.length; j++) {
        final a = _bubbles[i];
        final b = _bubbles[j];
        final dx = b.x - a.x;
        final dy = b.y - a.y;
        final distance = sqrt(dx * dx + dy * dy);
        final minDistance = a.radius + b.radius;

        if (distance < minDistance * 1.5 && distance >= minDistance) {
          final nx = dx / distance;
          final ny = dy / distance;
          const repulsionStrength = 0.05;
          a.dx -= nx * repulsionStrength;
          a.dy -= ny * repulsionStrength;
          b.dx += nx * repulsionStrength;
          b.dy += ny * repulsionStrength;
        }

        if (distance < minDistance) {
          final availableColorsA = colors.where((c) => c != a.color).toList();
          final availableColorsB = colors.where((c) => c != b.color).toList();
          if (availableColorsA.isNotEmpty) {
            a.color = availableColorsA[_random.nextInt(availableColorsA.length)];
          }
          if (availableColorsB.isNotEmpty) {
            b.color = availableColorsB[_random.nextInt(availableColorsB.length)];
          }

          final overlap = minDistance - distance;
          final pushFactor = 1.2;
          if (distance == 0) {
            final angle = _random.nextDouble() * 2 * pi;
            a.x -= cos(angle) * overlap * pushFactor / 2;
            a.y -= sin(angle) * overlap * pushFactor / 2;
            b.x += cos(angle) * overlap * pushFactor / 2;
            b.y += sin(angle) * overlap * pushFactor / 2;
          } else {
            final nx = dx / distance;
            final ny = dy / distance;
            final correction = overlap * pushFactor / 2;
            a.x -= nx * correction;
            a.y -= ny * correction;
            b.x += nx * correction;
            b.y += ny * correction;
          }
        }
      }
    }
  }

  List<Color> _getPastelColors() {
    return [
      const Color(0xFFF8E1E9),
      const Color(0xFFFDF0D5),
      const Color(0xFFE3F2FD),
      const Color(0xFFE0F7E9),
      const Color(0xFFEDE7F6),
    ];
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: const Text(
                " Find The Perfect Dress",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
            ),
            ..._bubbles.map((bubble) {
              return Positioned(
                left: bubble.x,
                top: bubble.y,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DressRecommendationPage(
                          occasion: bubble.label,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: bubble.radius * 2,
                    height: bubble.radius * 2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bubble.color,
                      border: Border.all(
                        color: Colors.pinkAccent.withOpacity(0.7),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          bubble.label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class _Bubble {
  String label;
  double x, y;
  double dx, dy;
  double radius;
  Color color;

  _Bubble({
    required this.label,
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.radius,
    required this.color,
  });
}
