import 'dart:math';
import 'package:flutter/material.dart';

class SpinningWheelPage extends StatefulWidget {
  final Color selectedColor;

  const SpinningWheelPage({Key? key, required this.selectedColor})
      : super(key: key);

  @override
  State<SpinningWheelPage> createState() => _SpinningWheelPageState();
}

class _SpinningWheelPageState extends State<SpinningWheelPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _angle = 0.0;
  bool _showColors = false;
  List<Color> complementaryColors = [];
  List<String> complementaryColorNames = [];

  final int segments = 6;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
      setState(() {});
    })..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _generateComplementaryColors();
        setState(() {
          _showColors = true;
        });
      }
    });
  }

  void _spinWheel() {
    setState(() {
      _showColors = false;
    });

    final random = Random();
    final spins = 5 + random.nextInt(3); // 5–7 full spins
    final target = random.nextDouble() * 2 * pi;
    _angle = 2 * pi * spins + target;

    _controller.reset();
    _controller.forward();
  }

  void _generateComplementaryColors() {
    final hsl = HSLColor.fromColor(widget.selectedColor);
    complementaryColors = [
      hsl.withHue((hsl.hue + 180) % 360).toColor(), // Complement
      hsl.withHue((hsl.hue + 150) % 360).toColor(), // Analog 1
      hsl.withHue((hsl.hue + 210) % 360).toColor(), // Analog 2
      hsl.withHue((hsl.hue + 30) % 360).toColor(),  // Split Complement
    ];

    // Generate the corresponding color names
    complementaryColorNames = [
      'Complementary',
      'Analog 1',
      'Analog 2',
      'Split Complement'
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double currentAngle = _angle * _animation.value;

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text("Color Match Wheel"),
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.expand_less, size: 40),
              const SizedBox(height: 10),

              // Display the selected color first
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: widget.selectedColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Selected Color",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: currentAngle,
                    child: CustomPaint(
                      size: const Size(250, 250),
                      painter: WheelPainter(segments: segments),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.palette, color: Colors.pink),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _spinWheel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                child: const Text('Spin the Wheel'),
              ),
              const SizedBox(height: 30),
              if (_showColors)
                Column(
                  children: [
                    const Text(
                      'Your Complementary Colors:',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: List.generate(complementaryColors.length, (index) {
                        return Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: complementaryColors[index],
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              complementaryColorNames[index],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final int segments;
  final List<Color> wheelColors = const [
    Colors.pinkAccent,
    Colors.orangeAccent,
    Colors.amber,
    Colors.green,
    Colors.lightBlue,
    Colors.purpleAccent,
  ];

  WheelPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final anglePerSegment = 2 * pi / segments;

    for (int i = 0; i < segments; i++) {
      paint.color = wheelColors[i % wheelColors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        anglePerSegment * i,
        anglePerSegment,
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
