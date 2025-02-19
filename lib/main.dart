import 'package:flutter/material.dart';

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

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
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

  Color _getPetColor() {
    if (happinessLevel > 70) {
      return Colors.green; // Happy pet
    } else if (happinessLevel >= 30) {
      return Colors.yellow; // Neutral pet
    } else {
      return Colors.red; // Unhappy pet
    }
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
            height: 200,
            width: 200,
            fit: BoxFit.cover,  // Ensures the image fits within the circle without distorting
          ),
        ),
      ),
      SizedBox(height: 16.0), // Spacing
      Text(
        'Name: $petName',
        style: TextStyle(fontSize: 20.0),
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
    ],
  ),
 ),
    );
  }
}