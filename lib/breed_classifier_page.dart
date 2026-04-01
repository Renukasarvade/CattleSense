import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class BreedClassifierPage extends StatefulWidget {
  const BreedClassifierPage({super.key});

  @override
  State<BreedClassifierPage> createState() => _BreedClassifierPageState();
}

class _BreedClassifierPageState extends State<BreedClassifierPage> {
  Interpreter? interpreter;
  File? selectedImage;
  String result = "📷 Pick an image to classify cattle breed";

  final List<String> classLabels = [
    "Brown Swiss",
    "Deoni",
    "Gir",
    "Hallikar",
    "Holstein Friesian",
    "Jaffrabadi",
    "Kangayam",
    "Kankrej",
    "Khillari",
    "Murrah",
    "Nagpuri",
    "Ongole",
    "Sahiwal",
    "Tharparkar",
    "Toda"
  ];

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('model/cattle_breed_classifier.tflite');
      print("✅ Cattle Breed Model Loaded Successfully");
    } catch (e) {
      print("❌ Model Loading Error: $e");
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
        result = "🧠 Classifying...";
      });
      await runInference(File(picked.path));
    }
  }

  Future<void> runInference(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? oriImage = img.decodeImage(bytes);

    if (oriImage == null) {
      setState(() => result = "❌ Failed to process image");
      return;
    }

    img.Image resized = img.copyResize(oriImage, width: 224, height: 224);

    var input = List.generate(
      1,
          (_) => List.generate(224, (y) => List.generate(224, (x) {
        final pixel = resized.getPixel(x, y);
        return [
          pixel.r / 255.0,
          pixel.g / 255.0,
          pixel.b / 255.0
        ];
      })),
    );

    var output = List.generate(1, (_) => List.filled(15, 0.0));

    try {
      interpreter?.run(input, output);
      print("Raw Output: $output");

      List<double> outputSoftmax = softmax(output[0]);
      int maxIndex = outputSoftmax.indexOf(outputSoftmax.reduce(max));

      setState(() {
        result = "✅ Breed Identified:\n📌 ${classLabels[maxIndex]}\n"
            "🔢 Confidence: ${(outputSoftmax[maxIndex] * 100).toStringAsFixed(2)}%";
      });
    } catch (e) {
      setState(() {
        result = "❌ Inference Failed: $e";
      });
    }
  }

  List<double> softmax(List<double> logits) {
    double maxLogit = logits.reduce(max);
    List<double> expLogits =
    logits.map((value) => exp(value - maxLogit)).toList();
    double sum = expLogits.reduce((a, b) => a + b);
    return expLogits.map((value) => value / sum).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/assets/home_bg1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Cattle Breed Classifier',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 25),

                    if (selectedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(selectedImage!, height: 240),
                      ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Pick Image & Classify",
                          style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 25),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        result,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
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
}
