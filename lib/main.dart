import 'package:flutter/material.dart';
import 'dart:async'; // For using Timer

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  final TextEditingController nameController = TextEditingController();
  bool isNameConfirmed = false;

  // Timer to automatically increase hunger level
  late Timer _hungerTimer;
  late Timer _winTimer;
  bool hasWon = false;

  @override
  void initState() {
    super.initState();
    _startHungerTimer(); // Start the timer when the app starts
  }

  // Function to start the timer for automatic hunger increase
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        _updateHappiness();
        _checkLossCondition();  // Check for loss condition every time hunger or happiness changes
      });
    });
  }

  // Function to stop the hunger timer when the app is disposed
  @override
  void dispose() {
    _hungerTimer.cancel();
    if (_winTimer.isActive) {
      _winTimer.cancel();
    }
    super.dispose();
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _checkWinCondition();  // Check for win condition every time happiness changes
      _checkLossCondition();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _checkLossCondition();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // Get color based on happiness level
  Color _getPetColor() {
    if (happinessLevel > 70) {
      return Colors.green; // Happy pet
    } else if (happinessLevel >= 30) {
      return Colors.yellow; // Neutral pet
    } else {
      return Colors.red; // Unhappy pet
    }
  }

  String _getMoodText() {
    if (happinessLevel > 70) {
      return "Happy";
    } else if (happinessLevel >= 30) {
      return "Neutral";
    } else {
      return "Unhappy";
    }
  }

  // Function to confirm pet name
  void _confirmPetName() {
    setState(() {
      petName = nameController.text.isEmpty ? petName : nameController.text;
      isNameConfirmed = true;
    });
  }

  // Check if win condition is met
  void _checkWinCondition() {
    if (happinessLevel > 80 && !hasWon) {
      // Start a timer to check if happiness stays above 80 for 1 minute
      _winTimer = Timer(Duration(minutes: 1), () {
        setState(() {
          hasWon = true;
        });
      });
    }
  }

  // Check if loss condition is met
  void _checkLossCondition() {
    if (hungerLevel == 100 && happinessLevel == 10) {
      _showGameOverDialog();
    }
  }

  // Show Game Over dialog
  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Hunger Level reached 100, and Happiness Level dropped to 10.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Name customization section
            if (!isNameConfirmed)
              Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Pet\'s Name',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _confirmPetName,
                    child: Text('Enter'),
                  ),
                ],
              ),
            if (isNameConfirmed)
              // Display pet mood and pet name
              Column(
                children: [
                  Text(
                    'Name: $petName',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    'Mood: ${_getMoodText()}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            SizedBox(height: 16.0),
            // Container wrapping both image and background color
            Container(
              width: 400,  // The size of the pet's background (circle)
              height: 400,
              decoration: BoxDecoration(
                color: _getPetColor(), // Dynamic color based on mood
                shape: BoxShape.circle, // Make it circular
              ),
              child: ClipOval(  // Clip the image to fit inside the circular container
                child: Image.network(
                  'https://www.cdc.gov/healthy-pets/media/images/2024/04/GettyImages-598175960-cute-dog-headshot.jpg',
                  height: 100,
                  width: 100,
                  // Ensures the image fits within the circle without distorting
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
            if (hasWon)
              Text(
                'You Win!',
                style: TextStyle(fontSize: 24.0, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
