import 'package:flutter/material.dart';
import 'home.dart';

class AttackerDetailsPage extends StatefulWidget {
  @override
  _AttackerDetailsPageState createState() => _AttackerDetailsPageState();
}

class _AttackerDetailsPageState extends State<AttackerDetailsPage> {
  String? _animalOwnership;
  String? _animalType;
  int? _age;
  String _ageUnit = 'Years'; // Default unit is 'Years
  String? _vaccinationStatus;
  String? _vaccinationState;
  String? _animalCondition;

  void _submitForm() {
    // After form submission, navigate to the success page with animation
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SuccessPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Attack'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Attacker\'s Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _animalOwnership,
              decoration: InputDecoration(
                labelText: 'Do you know what Animal it is?',
                border: OutlineInputBorder(),
                hintText: 'Select Category',
                hintStyle: TextStyle(color: Colors.purple),
              ),
              items: ['Owned', 'Stray'].map((ownership) => DropdownMenuItem<String>(
                value: ownership,
                child: Text(ownership),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _animalOwnership = value;
                });
              },
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _animalType,
              decoration: InputDecoration(
                labelText: 'What Kind of Animal it is?',
                border: OutlineInputBorder(),
                hintText: 'Select Species',
                hintStyle: TextStyle(color: Colors.purple),
              ),
              items: ['Dog', 'Cattle', 'Cat'].map((type) => DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _animalType = value;
                });
              },
            ),
            const SizedBox(height: 20),

            Column(
              children: [
                // Dropdown to select 'Months' or 'Years'
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: DropdownButtonFormField<String>(
                    value: _ageUnit, // Default value is 'Years'
                    decoration: InputDecoration(
                      labelText: 'Unit (Months/Years)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _ageUnit = newValue!; // Update the unit
                      });
                    },
                    items: <String>['Months', 'Years']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                // Age input field
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'How old is that species?',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter age';
                    }
                    int? age = int.tryParse(value);
                    if (age == null || age <= 0) {
                      return 'Please enter a valid number above 0';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _age = int.tryParse(value); // Update _age with the user input
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _vaccinationStatus,
              decoration: InputDecoration(
                labelText: 'Do you know its Vaccination Status?',
                border: OutlineInputBorder(),
                hintText: 'Select Vaccination Status',
                hintStyle: TextStyle(color: Colors.purple),
              ),
              items: ['Known', 'Unknown'].map((status) => DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _vaccinationStatus = value;
                });
              },
            ),
            const SizedBox(height: 20),

            if (_vaccinationStatus == 'Known')
              DropdownButtonFormField<String>(
                value: _vaccinationState,
                decoration: InputDecoration(
                  labelText: 'Select Vaccination Status',
                  border: OutlineInputBorder(),
                  hintText: 'Select Status',
                  hintStyle: TextStyle(color: Colors.purple),
                ),
                items: ['Vaccinated', 'Not Vaccinated'].map((state) => DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _vaccinationState = value;
                  });
                },
              ),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: _animalCondition,
              decoration: InputDecoration(
                labelText: 'How is it now?',
                border: OutlineInputBorder(),
                hintText: 'Condition of the Animal',
                hintStyle: TextStyle(color: Colors.purple),
              ),
              items: ['Natural Death', 'Dead with Rabies Symptoms', 'Alive with No Symptoms'].map((condition) => DropdownMenuItem<String>(
                value: condition,
                child: Text(condition),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _animalCondition = value;
                });
              },
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _submitForm,
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                shadowColor: Colors.black,
                elevation: 5,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                //side: BorderSide(color: Colors.tealAccent, width: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Submitted'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              'Report submitted successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Button text color
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Background color
                  foregroundColor: Colors.white, // Text and icon color when pressed
                  shadowColor: Colors.black, // Shadow color
                  elevation: 5, // Elevation for shadow effect
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Padding around the text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  //side: BorderSide(color: Colors.tealAccent, width: 2), // Border around the button
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
