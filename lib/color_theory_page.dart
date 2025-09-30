import 'package:flutter/material.dart';

class ColorTheoryPage extends StatefulWidget {
  const ColorTheoryPage({super.key});

  @override
  _ColorTheoryPageState createState() => _ColorTheoryPageState();
}

class _ColorTheoryPageState extends State<ColorTheoryPage> {
  final List<Color> skinTones = [
    // Group 1
    Color(0xFFFFF5EB), Color(0xFFFFF1E6), Color(0xFFFFEEE1),
    Color(0xFFFFEAD9), Color(0xFFFFE7D6), Color(0xFFFFE4D1),
    // Group 2
    Color(0xFFFFE1CB), Color(0xFFFFDDC6), Color(0xFFFFDAC1),
    Color(0xFFFFD6BC), Color(0xFFFFD3B6), Color(0xFFFFD0B0),
    // Group 3
    Color(0xFFFBCDA9), Color(0xFFF8CBA3), Color(0xFFF5C89E),
    Color(0xFFF2C298), Color(0xFFEFBF92), Color(0xFFEAB98B),
    // Group 4
    Color(0xFFE6B485), Color(0xFFE3AF7F), Color(0xFFDDA878),
    Color(0xFFD8A272), Color(0xFFD39B6B), Color(0xFFCE9565),
    // Group 5
    Color(0xFFCA8E5E), Color(0xFFC48858), Color(0xFFBF8252),
    Color(0xFFBA7B4B), Color(0xFFB47445), Color(0xFFAF6E3F),
    // Group 6
    Color(0xFFA96739), Color(0xFFA46133), Color(0xFF9E5A2D),
    Color(0xFF995427), Color(0xFF934E22), Color(0xFF874118),
  ];

  final List<String> veinTypes = ["Blue", "Green", "Purple"];

  int _selectedSkinIndex = -1;
  int _selectedVeinIndex = -1;

  final Map<String, List<List<Color>>> personalizedToneDetails = {
    "Cool": [
      [Colors.lightBlueAccent, Color(0xFFE0BBE4), Color(0xFF957DAD)],
      [Colors.indigo, Color(0xFF98DDCA), Color(0xFF80CED6)],
      [Color(0xFFB5EAD7), Color(0xFFC7CEEA), Color(0xFF779ECB)],
      [Color(0xFF5D8AA8), Color(0xFF92A8D1), Color(0xFF6B5B95)],
      [Color(0xFFB39EB5), Color(0xFF83677B), Color(0xFFB2C9AB)],
      [Color(0xFF5C5470), Color(0xFF7A9E9F), Color(0xFF88BDBC)],
    ],
    "Warm": [
      [Colors.deepOrange, Color(0xFFFFCC99), Color(0xFFFFB347)],
      [Colors.orange, Color(0xFFFFA07A), Color(0xFFFF7F50)],
      [Color(0xFFFFD700), Color(0xFFFFE4B5), Color(0xFFFFC0CB)],
      [Color(0xFFFF6347), Color(0xFFFF8C69), Color(0xFFFFB6C1)],
      [Color(0xFFE9967A), Color(0xFFF08080), Color(0xFFD2691E)],
      [Color(0xFFFFE5B4), Color(0xFFB5651D), Color(0xFFB87333)],
    ],
    "Neutral": [
      [Colors.grey, Colors.white, Color(0xFFF5F5DC)],
      [Color(0xFF483C32), Color(0xFF6B6E4E), Color(0xFFBEBEBE)],
      [Color(0xFFDFD7BD), Color(0xFFCCCCCC), Color(0xFFD3D3D3)],
      [Color(0xFFEEE8AA), Color(0xFFE6E6FA), Color(0xFFF8F8FF)],
      [Color(0xFFFAF0E6), Color(0xFFE0E0E0), Color(0xFFC0C0C0)],
      [Color(0xFFDEB887), Color(0xFFA9A9A9), Color(0xFFB0C4DE)],
    ],
  };

  List<Color> getSelectedColors() {
    if (_selectedSkinIndex == -1 || _selectedVeinIndex == -1) return [];

    int skinGroup = (_selectedSkinIndex / 6).floor();

    switch (_selectedVeinIndex) {
      case 0:
        return personalizedToneDetails["Cool"]![skinGroup];
      case 1:
        return personalizedToneDetails["Warm"]![skinGroup];
      case 2:
        return personalizedToneDetails["Neutral"]![skinGroup];
      default:
        return [];
    }
  }

  String getSelectedLabel() {
    if (_selectedSkinIndex == -1 || _selectedVeinIndex == -1) return "";

    switch (_selectedVeinIndex) {
      case 0:
        return "Cool Tone Suggestions";
      case 1:
        return "Warm Tone Suggestions";
      case 2:
        return "Neutral Tone Suggestions";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedColors = getSelectedColors();
    final label = getSelectedLabel();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Theory'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Your Skin Tone',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: skinTones.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() => _selectedSkinIndex = index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: skinTones[index],
                    border: Border.all(
                      color: _selectedSkinIndex == index
                          ? Colors.black
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Select Vein Color',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(veinTypes.length, (index) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedVeinIndex = index);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedVeinIndex == index
                        ? Colors.deepPurple
                        : Colors.grey,
                  ),
                  child: Text(veinTypes[index]),
                );
              }),
            ),
            const SizedBox(height: 30),
            if (selectedColors.isNotEmpty && label.isNotEmpty) ...[
              Text(
                label,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedColors.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemBuilder: (context, index) => Container(
                  height: 40,
                  width: 40,
                  color: selectedColors[index],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
