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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FirstQuestionPage()),
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

class FirstQuestionPage extends StatelessWidget {
  void _nextQuestion(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondQuestionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Full-screen background image
          Image.network(
            'https://img.freepik.com/free-photo/vertical-shot-grey-cat-with-blue-eyes-dark_181624-34787.jpg?size=626&ext=jpg&ga=GA1.1.1819120589.1728086400&semt=ais_hybrid',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Centered content on top of the background image
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20), // Adjust the horizontal padding as needed
              child: Container(
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.grey[300]?.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Was the first aid given?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _nextQuestion(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black12,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                            'Yes',
                            style: TextStyle(
                               fontSize: 16,
                               fontWeight: FontWeight.bold,
                               color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _nextQuestion(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black12,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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

class SecondQuestionPage extends StatelessWidget {
  void _finish(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuccessPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Full-screen background image
          Image.network(
            'https://img.freepik.com/free-photo/vertical-shot-grey-cat-with-blue-eyes-dark_181624-34787.jpg?size=626&ext=jpg&ga=GA1.1.1819120589.1728086400&semt=ais_hybrid',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Centered content on top of the background image
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20), // Adjust the horizontal padding as needed
              child: Container(
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.grey[300]?.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Was the bite washed for 15 mins in tap water?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _finish(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black12,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _finish(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black12,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    // Start the fade-in animation
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 5),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    'Thanks doctor :) Your report has been '
                        'recorded and your response has been '
                        'saved successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ScaleTransition(
              scale: Tween<double>(begin: 1.0, end: 1.2).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
              ),
              child: ElevatedButton(
                onPressed: () {
                  //_controller.forward().then((_) => _controller.reverse());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
