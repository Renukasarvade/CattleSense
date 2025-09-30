import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class OutfitClassifierPage extends StatefulWidget {
  const OutfitClassifierPage({super.key});

  @override
  State<OutfitClassifierPage> createState() => _OutfitClassifierPageState();
}

class _OutfitClassifierPageState extends State<OutfitClassifierPage> {
  Interpreter? interpreter;
  File? selectedImage;
  String result = "📷 Pick an image to run model";

  final List<String> classLabels = [
    "Business",
    "Other",
    "Casual",
    "Night Party",
    "Sports",
    "Wedding"
  ];

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/model/model.tflite');
      print("✅ Model loaded");
    } catch (e) {
      print("❌ Failed to load model: $e");
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
        result = "🧠 Running model...";
      });
      await runInference(File(picked.path));
    }
  }

  Future<void> runInference(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? oriImage = img.decodeImage(bytes);
    if (oriImage == null) {
      setState(() => result = "❌ Couldn't decode image");
      return;
    }

    img.Image resized = img.copyResize(oriImage, width: 224, height: 224);

    var input = List.generate(
      1,
          (_) => List.generate(
        224,
            (y) => List.generate(
          224,
              (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0
            ];
          },
        ),
      ),
    );

    var output = List.filled(6, 0.0).reshape([1, 6]);

    try {
      interpreter?.run(input, output);
      print("Raw output: $output");

      var outputWithSoftmax = softmax(output[0]);

      int predictedIndex = outputWithSoftmax.indexOf(
        outputWithSoftmax.reduce((a, b) => a > b ? a : b),
      );

      String predictedLabel = classLabels[predictedIndex];

      // 📝 Define contextual messages
      Map<String, String> contextMessages = {
        "Wedding": "Wedding, Engagement, Festivals",
        "Casual": "Cafe, Outing, Hangouts",
        "Night Party": "Club, Reception, Celebrations",
        "Sports": "Gym, Outdoor Activities, Running",
        "Business": "Office, Meetings, Conferences",
        "Other": "General, Unclassified, Mixed"
      };

      setState(() {
        result = "✅ Prediction: $predictedLabel\n"
            "📌 Suitable for: ${contextMessages[predictedLabel] ?? 'Various Occasions'}";
      });
    } catch (e) {
      setState(() {
        result = "❌ Inference failed: $e";
      });
    }
  }

  List<double> softmax(List<double> logits) {
    double maxLogit = logits.reduce(max);
    List<double> expLogits = logits.map((logit) => exp(logit - maxLogit)).toList();
    double sumExp = expLogits.reduce((a, b) => a + b);
    return expLogits.map((e) => e / sumExp).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/assets/home_bg1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Overlay content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Outfit Classifier',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (selectedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          selectedImage!,
                          height: 250,
                        ),
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Pick Image & Run Model",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        result,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
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

