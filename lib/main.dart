//Isaac Lara
import 'dart:async';

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
  String moodLevel = "Neutral";
  String selectedActivity = "Play";
  double energyLevel = 0.5;

  // Timer to update the pet's hunger and happiness levels
  Timer? timer;
  Timer? winTimer;
  bool isWinning = false;
  int winDuration = 180; // 3 minutes in seconds

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(Duration(seconds: 30), (Timer t) => hungerUpdater(this));
  }

  @override
  void dispose() {
    timer?.cancel();
    winTimer?.cancel();
    super.dispose();
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _updateMood();
      _checkWinCondition();
      _updateEnergy();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _updateMood();
      _checkWinCondition();
      _updateEnergy();
    });
  }

  // Function to perform the selected activity
  void _performActivity() {
    if (selectedActivity == "Play") {
      _playWithPet();
    } else if (selectedActivity == "Feed") {
      _feedPet();
    }
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
    if (hungerLevel >= 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
      _checkWinCondition();
    }
  }

  // function to update the pet's hunger and happiness levels every second
  void hungerUpdater(_DigitalPetAppState state) {
    setState(() {
      hungerLevel = (hungerLevel + 20).clamp(0, 100);
      happinessLevel = (happinessLevel - 10).clamp(0, 100);
      _checkWinCondition();
    });
  }

  // Check if the win condition is met
  void _checkWinCondition() {
    if (happinessLevel > 80) {
      if (!isWinning) {
        isWinning = true;
        winTimer = Timer(Duration(seconds: winDuration), _winGame);
      }
    } else {
      isWinning = false;
      winTimer?.cancel();
    }
  }

  // Function to handle winning the game
  void _winGame() {
    if (isWinning) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("You Win!"),
            content:
                Text("Congratulations! Your pet has been happy for 3 minutes!"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _updateMood() {
    if (happinessLevel < 30) {
      moodLevel = "Unhappy";
    } else if (happinessLevel < 70) {
      moodLevel = "Neutral";
    } else {
      moodLevel = "Happy";
    }
  }

  void _onChanged(String value) {
    setState(() => petName = '${value}');
  }

  void _updateEnergy() {
    if (happinessLevel < 30 && hungerLevel < 30) {
      energyLevel = 0.2;
    } else if (happinessLevel < 50 && hungerLevel < 50) {
      energyLevel = 0.3;
    } else if (happinessLevel < 70 && hungerLevel < 70) {
      energyLevel = 0.6;
    } else {
      energyLevel = 0.9;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      backgroundColor: happinessLevel < 30
          ? Colors.red
          : happinessLevel < 70
              ? Colors.yellow
              : Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            SizedBox(height: 16.0),
            Text(
              'Mood: $moodLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            DropdownButton<String>(
              value: selectedActivity,
              onChanged: (String? newValue) {
                setState(() {
                  selectedActivity = newValue!;
                });
              },
              items: <String>['Play', 'Feed']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            LinearProgressIndicator(
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              value: energyLevel,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _performActivity,
              child: Text('Perform Activity'),
            ),
            SizedBox(height: 16.0),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: _onChanged,
            ),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: _onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
