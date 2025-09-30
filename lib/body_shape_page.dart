import 'package:flutter/material.dart';

// Import your shape pages here
import 'apple_page.dart';
import 'pear_page.dart';
import 'hourglass_page.dart';
import 'triangle_page.dart';
import 'rectangle_page.dart';

class BodyShapePage extends StatefulWidget {
  const BodyShapePage({super.key});

  @override
  _BodyShapePageState createState() => _BodyShapePageState();
}

class _BodyShapePageState extends State<BodyShapePage> {
  final TextEditingController _chestController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _hipController = TextEditingController();

  String _bodyShape = '';
  String _message = '';

  void calculateBodyShape() {
    final chest = double.tryParse(_chestController.text) ?? 0;
    final waist = double.tryParse(_waistController.text) ?? 0;
    final hip = double.tryParse(_hipController.text) ?? 0;

    if (chest == 0 || waist == 0 || hip == 0) {
      setState(() {
        _bodyShape = '';
        _message = 'Please enter all measurements to determine your body shape.';
      });
      return;
    }

    // Calculate ratios for more accurate classifications
    double chestWaistRatio = chest / waist;
    double waistHipRatio = waist / hip;
    double chestHipRatio = chest / hip;

    if ((chest - hip).abs() <= 2 && waist < chest && waist < hip) {
      // Hourglass Shape: Balanced chest and hips, waist smaller
      _bodyShape = 'Hourglass';
      _message = 'Balanced chest and hips with smaller waist.';
    } else if (hip > chest && waist < chest && waist < hip) {
      // Pear Shape: Hips larger than chest and waist
      _bodyShape = 'Pear';
      _message = 'Hips are larger than chest and waist.';
    } else if (chest > hip && chest > waist && chestWaistRatio > 1.2) {
      // Apple Shape: Chest larger, waist and hips smaller, larger chest-waist ratio
      _bodyShape = 'Apple';
      _message = 'Chest is broader than waist and hips.';
    } else if (chest > hip && waist > hip && chestHipRatio > 1.1) {
      // Triangle Shape: Shoulders/chest wider than hips, larger chest-hip ratio
      _bodyShape = 'Triangle';
      _message = 'Shoulders/chest are wider than hips.';
    } else if (chestWaistRatio < 1.1 && waistHipRatio < 1.1) {
      // Rectangle Shape: Chest, waist, and hips are almost equal
      _bodyShape = 'Rectangle';
      _message = 'All measurements are fairly equal.';
    } else {
      _bodyShape = 'Rectangle';
      _message = 'Body shape is more balanced and symmetrical.';
    }

    setState(() {});
  }


  void navigateToShapePage() {
    Widget page;
    switch (_bodyShape) {
      case 'Hourglass':
        page = const HourglassPage();
        break;
      case 'Pear':
        page = const PearPage();
        break;
      case 'Apple':
        page = const ApplePage();
        break;
      case 'Triangle':
        page = const TrianglePage();
        break;
      default:
        page = const RectanglePage();
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Body Shape Finder'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/assets/home_bg.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: const Color(0xFFFFE4E1).withOpacity(0.6),
          ),
          SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Measurement',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildInputField('Chest (inches)', _chestController),
                    const SizedBox(height: 20),
                    _buildInputField('Waist (inches)', _waistController),
                    const SizedBox(height: 20),
                    _buildInputField('Hip (inches)', _hipController),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          calculateBodyShape();
                          FocusScope.of(context).unfocus();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Find Body Shape'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (_message.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$_bodyShape Shape',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: navigateToShapePage,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(30),
                              backgroundColor: Colors.pinkAccent,
                              elevation: 10,
                            ),
                            child: const Icon(Icons.local_florist, size: 40, color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Explore Your Shape",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
      keyboardType: TextInputType.number,
    );
  }
}

