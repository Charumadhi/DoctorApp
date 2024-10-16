import 'package:flutter/material.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For encoding JSON objects

class AttackerDetailsPage extends StatefulWidget {

  final Map<String, dynamic> doctor;
  final Map<String, dynamic> victim;

  AttackerDetailsPage({required this.doctor, required this.victim});

  @override
  _AttackerDetailsPageState createState() => _AttackerDetailsPageState();
}

class _AttackerDetailsPageState extends State<AttackerDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String? _species;
  String? _breed;
  int? _age;
  bool _vaccinationStatus = false; // tinyint in the backend (true/false)
  String? _animalCondition;
  String? _gender;
  //int? _pincode;

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      print("Form is valid, navigating to FirstQuestionPage");
      Map<String, dynamic> attacker = {
        'species': _species,
        'age': _age,
        'sex': _gender,
        'breed': _breed,
        'vaccinationStatus': _vaccinationStatus,
        'condition': _animalCondition,
       // 'pincode': _pincode,
      };
      print("Moving to first question page");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FirstQuestionPage(
          doctor: widget.doctor,
          victim: widget.victim,
          attacker: attacker,
        )),
      );
    }
  }

  Widget _buildDropdownField(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      ))
          .toList(),
      onChanged: onChanged,
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
        child: Form( // Make sure to wrap your Column in a Form widget
          key: _formKey, // Use the _formKey
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

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'What kind of species is it?',  // Label for the text field
                  border: OutlineInputBorder(),  // Border around the text field
                ),
                onChanged: (value) {
                  setState(() {
                    _species = value;  // Store the input text in a variable
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the species';  // Validation message
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'What kind of breed is it?',  // Label for the text field
                  border: OutlineInputBorder(),  // Border around the text field
                ),
                onChanged: (value) {
                  setState(() {
                    _breed = value;  // Store the input text in a variable
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the breed';  // Validation message
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Column(
                children: [
                  // Dropdown to select 'Months' or 'Years'
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                  //   child: DropdownButtonFormField<String>(
                  //     value: _ageUnit, // Default value is 'Years'
                  //     decoration: InputDecoration(
                  //       labelText: 'Unit (Months/Years)',
                  //       border: OutlineInputBorder(),
                  //     ),
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         _ageUnit = newValue!; // Update the unit
                  //       });
                  //     },
                  //     items: <String>['Months', 'Years']
                  //         .map<DropdownMenuItem<String>>((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         child: Text(value),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
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
              _buildDropdownField('What gender is it?', _gender, ['M', 'F'], (value) {
                setState(() {
                  _gender = value;
                });
              }),
              // const SizedBox(height: 20),
              // TextFormField(
              //   decoration: InputDecoration(
              //     labelText: 'Please enter the pincode where the attack happened.',  // Label for the text field
              //     border: OutlineInputBorder(),  // Border around the text field
              //   ),
              //   onChanged: (value) {
              //     setState(() {
              //       _pincode = int.tryParse(value);  // Safely parse to int
              //     });
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter the pincode';  // Validation message
              //     }
              //     // Optional: You can add more validation here to check the length or format of the pincode
              //     if (value.length != 6) {
              //       return 'Please enter a valid 6-digit pincode';  // Example additional validation
              //     }
              //     return null;  // Valid input
              //   },
              // ),
              //
              // const SizedBox(height: 20),

              // DropdownButtonFormField<String>(
              //   value: _vaccinationStatus,
              //   decoration: InputDecoration(
              //     labelText: 'Do you know its Vaccination Status?',
              //     border: OutlineInputBorder(),
              //     hintText: 'Select Vaccination Status',
              //     hintStyle: TextStyle(color: Colors.purple),
              //   ),
              //   items: ['Known', 'Unknown'].map((status) => DropdownMenuItem<String>(
              //     value: status,
              //     child: Text(status),
              //   )).toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       _vaccinationStatus = value;
              //     });
              //   },
              // ),
              // const SizedBox(height: 20),

              _buildDropdownField('Vaccination Status', _vaccinationStatus ? '1' : '0', ['1', '0'], (value) {
                setState(() {
                  _vaccinationStatus = value == '1'; // Convert to tinyint
                });
              }),
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
      ),
    );
  }
}

class FirstQuestionPage extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final Map<String, dynamic> victim;
  final Map<String, dynamic> attacker;

  FirstQuestionPage({required this.doctor, required this.victim, required this.attacker});

  @override
  _FirstQuestionPageState createState() => _FirstQuestionPageState();
}

class _FirstQuestionPageState extends State<FirstQuestionPage> {

  Future<void> _nextQuestion(BuildContext context, String firstaidStatus) async {
    // Update victim with the first aid status
    widget.victim['firstAidStatus'] = firstaidStatus;

    // Prepare the payload for API request
    Map<String, dynamic> dataToSend = {
      'doctor': widget.doctor,
      'victim': widget.victim,
      'attacker': widget.attacker,
    };

    final url = Uri.parse('https://rabitrack-backend-production.up.railway.app/addNewCase');

    try {
      // Send POST request with the combined data
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataToSend), // Use combined data for submission
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SuccessPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit data: ${response.body}')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error occurred: $error')));
    }
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
                          onPressed: () => _nextQuestion(context, 'Yes'),
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
                          onPressed: () => _nextQuestion(context, 'No'),
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
  bool _isLoading = false;

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
                  //controller.forward().then(() => _controller.reverse());
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