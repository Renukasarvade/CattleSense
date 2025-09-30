import 'package:flutter/material.dart';

class FashionQuizPage extends StatefulWidget {
  const FashionQuizPage({super.key});

  @override
  State<FashionQuizPage> createState() => _FashionQuizPageState();
}

class _FashionQuizPageState extends State<FashionQuizPage> {
  final List<Question> questions = [
    Question(
      text: 'How do you usually dress for a casual day out?',
      options: ['Trendy & Bold', 'Classic & Simple', 'Sporty', 'Elegant', 'Bohemian', 'Street Style'],
    ),
    Question(
      text: 'Pick a favorite fashion item:',
      options: ['Leather Jacket', 'White Shirt', 'Sneakers', 'Silk Scarf', 'Denim Jeans', 'Blazer'],
    ),
    Question(
      text: 'Which color palette attracts you the most?',
      options: ['Neon', 'Neutrals', 'Bold', 'Pastels', 'Earth Tones', 'Metallic'],
    ),
    Question(
      text: 'What kind of footwear do you prefer?',
      options: ['Heels', 'Flats', 'Boots', 'Sneakers', 'Loafers', 'Sandals'],
    ),
    Question(
      text: 'Pick a fashion icon:',
      options: ['Zendaya', 'Kate Middleton', 'Rihanna', 'Kendall Jenner', 'Harry Styles', 'Deepika Padukone'],
    ),
    Question(
      text: 'Which accessory do you love most?',
      options: ['Sunglasses', 'Watch', 'Handbag', 'Hat', 'Jewelry', 'Scarf'],
    ),
    Question(
      text: 'Your dream outfit includes:',
      options: ['Statement Coat', 'Maxi Dress', 'Graphic Tee', 'Tuxedo', 'Crop Top', 'Oversized Hoodie'],
    ),
    Question(
      text: 'Your favorite fabric?',
      options: ['Denim', 'Cotton', 'Silk', 'Leather', 'Linen', 'Velvet'],
    ),
  ];

  int currentQuestionIndex = 0;
  Map<String, int> answersCount = {};

  void _answer(String answer) {
    setState(() {
      answersCount[answer] = (answersCount[answer] ?? 0) + 1;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    String result = _calculateResult();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Your Fashion Persona'),
        content: Text('You are: $result!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  String _calculateResult() {
    if (answersCount.isEmpty) return "Undefined";
    String topChoice = answersCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    if (['Trendy & Bold', 'Neon', 'Leather Jacket', 'Statement Coat', 'Graphic Tee'].contains(topChoice)) {
      return 'Trendsetter';
    } else if (['Classic & Simple', 'Neutrals', 'White Shirt', 'Watch', 'Blazer'].contains(topChoice)) {
      return 'Minimalist';
    } else if (['Sporty', 'Sneakers', 'Oversized Hoodie', 'Flats'].contains(topChoice)) {
      return 'Athleisure Lover';
    } else if (['Elegant', 'Silk Scarf', 'Pastels', 'Silk'].contains(topChoice)) {
      return 'Chic & Elegant';
    } else if (['Bohemian', 'Earth Tones', 'Maxi Dress', 'Hat'].contains(topChoice)) {
      return 'Boho Spirit';
    } else {
      return 'Eclectic';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC0CB),
        title: const Text('Fashion Quiz', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFFFF0F5),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q${currentQuestionIndex + 1}. ${currentQuestion.text}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...currentQuestion.options.map(
                  (option) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 2,
                  ),
                  onPressed: () => _answer(option),
                  child: Text(option),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String text;
  final List<String> options;
  Question({required this.text, required this.options});
}
