import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class VirtualTryOnPage extends StatefulWidget {
  const VirtualTryOnPage({Key? key}) : super(key: key);

  @override
  _VirtualTryOnPageState createState() => _VirtualTryOnPageState();
}

class _VirtualTryOnPageState extends State<VirtualTryOnPage> {
  Uint8List? userImageBytes;
  Uint8List? outfitImageBytes;
  final picker = ImagePicker();

  // Pick the user image
  Future<void> pickUserImage() async {
    try {
      // Request gallery permission
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gallery access denied. Please enable in settings.")),
        );
        await openAppSettings(); // Prompt user to enable permissions
        return;
      }

      // Pick image from gallery
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user image selected")),
        );
        return;
      }

      // Read image bytes
      final bytes = await picked.readAsBytes();
      setState(() {
        userImageBytes = bytes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking user image: $e")),
      );
    }
  }

  // Pick the outfit image
  Future<void> pickOutfitImage() async {
    try {
      // Request gallery permission
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gallery access denied. Please enable in settings.")),
        );
        await openAppSettings(); // Prompt user to enable permissions
        return;
      }

      // Pick image from gallery
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No outfit image selected")),
        );
        return;
      }

      // Read image bytes
      final bytes = await picked.readAsBytes();
      setState(() {
        outfitImageBytes = bytes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking outfit image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Virtual Try-On")),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // User Image Preview
              if (userImageBytes != null) ...[
                const Text("User Image", style: TextStyle(fontWeight: FontWeight.bold)),
                Image.memory(userImageBytes!, width: 300, height: 300, fit: BoxFit.contain),
                const SizedBox(height: 20),
              ],
              // Outfit Image Preview
              if (outfitImageBytes != null) ...[
                const Text("Outfit Image", style: TextStyle(fontWeight: FontWeight.bold)),
                Image.memory(outfitImageBytes!, width: 300, height: 300, fit: BoxFit.contain),
                const SizedBox(height: 20),
              ],
              // Instructions
              if (userImageBytes == null && outfitImageBytes == null)
                const Text("Select user and outfit images below"),
              const SizedBox(height: 20),
              // Buttons
              ElevatedButton(
                onPressed: pickUserImage,
                child: const Text("Pick User Image"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickOutfitImage,
                child: const Text("Pick Outfit Image"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}