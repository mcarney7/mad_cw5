import 'dart:math';
import 'package:flutter/material.dart';
import 'fish.dart';
import 'database_helper.dart';

class AquariumScreen extends StatefulWidget {
  @override
  _AquariumScreenState createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen> with TickerProviderStateMixin {
  List<Fish> fishList = [];
  String selectedFish = 'Orange Fish';
  double selectedSpeed = 1.0; // Start with slowest speed
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 30),
    )..addListener(() {
        setState(() {
          for (var fish in fishList) {
            fish.moveFish(Size(300, 300)); // Move fish inside the 300x300 container
          }
        });
      });

    _controller.repeat(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadSavedSettings() async {
    var savedFish = await DatabaseHelper.instance.loadFish();
    setState(() {
      fishList = savedFish;
    });
  }

  void _addFish() {
    if (fishList.length < 10) {
      String imagePath;
      switch (selectedFish) {
        case 'Orange Fish':
          imagePath = 'assets/fish1.png';
          break;
        case 'White Stripped Fish':
          imagePath = 'assets/fish2.png';
          break;
        case 'Blue Fish':
          imagePath = 'assets/fish3.png';
          break;
        default:
          imagePath = 'assets/fish1.png';
      }
      setState(() {
        fishList.add(Fish(
          name: selectedFish,
          speed: selectedSpeed,
          position: Offset(Random().nextDouble() * 300, Random().nextDouble() * 300),
          imagePath: imagePath,
        ));
      });
    }
  }

  void _saveSettings() {
    DatabaseHelper.instance.saveFish(fishList);
  }

  void _resetAquarium() {
    setState(() {
      fishList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Aquarium'),
      ),
      body: Column(
        children: [
          Container(
            width: 300,
            height: 300,
            color: Colors.lightBlue[100],
            child: Stack(
              children: fishList.map((fish) {
                return Positioned(
                  left: fish.position.dx,
                  top: fish.position.dy,
                  child: Image.asset(
                    fish.imagePath,
                    width: fish.size,
                    height: fish.size,
                  ),
                );
              }).toList(),
            ),
          ),
          Slider(
            value: selectedSpeed,
            min: 1,
            max: 5,
            divisions: 4,
            label: 'Speed: ${selectedSpeed.toInt()}',
            onChanged: (value) {
              setState(() {
                selectedSpeed = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selectedFish,
                items: ['Orange Fish', 'White Stripped Fish', 'Blue Fish'].map((String fish) {
                  return DropdownMenuItem<String>(
                    value: fish,
                    child: Text(fish),
                  );
                }).toList(),
                onChanged: (String? newFish) {
                  setState(() {
                    selectedFish = newFish!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _addFish,
                child: Text('Add Fish'),
              ),
              ElevatedButton(
                onPressed: _saveSettings,
                child: Text('Save Settings'),
              ),
              ElevatedButton(
                onPressed: _resetAquarium,
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
