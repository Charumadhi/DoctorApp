import 'dart:convert';  // For encoding JSON objects

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'home.dart';

class AttackerDetailsPage extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final Map<String, dynamic> victim;
  final Map<String, dynamic> owner;
  final String jwtToken;

  const AttackerDetailsPage({
    Key? key,
    required this.doctor,
    required this.victim,
    required this.jwtToken,
    required this.owner,
  }) : super(key: key);

  @override
  _AttackerDetailsPageState createState() => _AttackerDetailsPageState();
}

class _AttackerDetailsPageState extends State<AttackerDetailsPage> {
  @override
  void initState() {
    super.initState();
    print('JWT Token from attack from: ${widget.jwtToken}'); // Print the token here
  }

  final _formKey = GlobalKey<FormState>();
  DateTime? lastVaccinatedOn;
  String? _species;
  String? _breed;
  String? _age;
  String? _vaccinationStatus; // tinyint in the backend (true/false)
  String? _animalCondition;
  String? _gender;
  String? _combinedBreed;

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      print("Form is valid, navigating to FirstQuestionPage");
      Map<String, dynamic> attacker = {
        'species': _species,
        'age': _age,
        'sex': _gender,
        'breed': _combinedBreed, // Combined breed value here
        'vaccinationStatus': _vaccinationStatus,
        'status': _animalCondition,
        'lastVaccinatedOn': lastVaccinatedOn, // Store the vaccinated date
      };
      print("Moving to first question page");

      // Print both maps to the terminal
      print('Doctor Details:');
      widget.doctor.forEach((key, value) {
        print('$key: $value');
      });

      print('Victim Details:');
      widget.victim.forEach((key, value) {
        print('$key: $value');
      });

      print('Owner Details:');
      widget.owner.forEach((key, value) {
        print('$key: $value');
      });

      print('Attacker Details: $attacker');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FirstQuestionPage(
            doctor: widget.doctor,
            victim: widget.victim,
            attacker: attacker,
            owner: widget.owner,
            jwtToken: widget.jwtToken,
          ),
        ),
      );
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != lastVaccinatedOn) {
      setState(() {
        lastVaccinatedOn = picked;
      });
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

  Widget _buildTextField(String label, ValueChanged<String> onChanged, {String? initialValue, String? Function(String?)? validator, TextInputType? keyboardType,}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Attack'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                decoration: InputDecoration(
                  labelText: 'What kind of species is it?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                value: _species,
                items: ['Dog', 'Cat', 'Goat', 'Cattle', 'Poultry', 'Sheep', 'Unknown']
                    .map((species) => DropdownMenuItem<String>(
                  value: species,
                  child: Text(species),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _species = value!;
                  });
                },
                hint: Text('Select species'),
              ),
              const SizedBox(height: 20),

              // Dropdown for breed selection
              _buildDropdownField(
                'What kind of breed is it?',
                _combinedBreed,
                ['Pure breed', 'Cross breed', 'Non-Descript (specify)'], // List of breed options
                    (value) {
                  setState(() {
                    _combinedBreed = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Conditional text field for specifying breed
              if (_combinedBreed == 'Non-Descript (specify)')
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Specify the breed',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _combinedBreed = 'Non-Descript (specify): $value'; // Combine both values
                    });
                  },
                  validator: (value) {
                    if (_combinedBreed == 'Non-Descript (specify): $value' && (value == null || value.isEmpty)) {
                      return 'Please specify the breed'; // Validation message
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 20),

              // Age input field
              _buildTextField(
                'How old is that species?',
                    (value) {
                  setState(() {
                    _age = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Gender selection
              _buildDropdownField(
                'What gender is it?',
                _gender ,['M', 'F', 'Unknown'],
                    (value) {
                  setState(() {
                    _gender = value; // Store 'Unknown' if no value is selected
                  });
                },
              ),
              const SizedBox(height: 20),

              // Vaccination Status dropdown
              DropdownButtonFormField<String>(
                value: _vaccinationStatus,
                items: [
                  DropdownMenuItem<String>(
                    value: 'Vaccinated',
                    child: Text('Vaccinated'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Not Vaccinated',
                    child: Text('Not Vaccinated'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Not Known',
                    child: Text('Not Known'),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _vaccinationStatus = value; // Store the selected string directly
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Vaccination Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 20),

              // Animal condition dropdown
              _buildDropdownField(
                'How is it now?',
                _animalCondition,
                ['Natural Death', 'Dead with Rabies Signs', 'Alive with No Signs', 'Unknown'],
                    (value) => setState(() => _animalCondition = value),
              ),
              const SizedBox(height: 20),

              // Date field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vaccinated Date: ${lastVaccinatedOn != null ? "${lastVaccinatedOn!.day}/${lastVaccinatedOn!.month}/${lastVaccinatedOn!.year}" : "Not selected"}',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Submit button
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
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 5,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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
  final Map<String, dynamic> owner;
  final String jwtToken;

  FirstQuestionPage({
    required this.doctor,
    required this.victim,
    required this.attacker,
    required this.owner,
    required this.jwtToken,
  });

  @override
  _FirstQuestionPageState createState() => _FirstQuestionPageState();
}

class _FirstQuestionPageState extends State<FirstQuestionPage> {
  // Define the GlobalKey for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variable for vaccination dose dropdown
  int? dose; // Default value of dose to null
  DateTime? date;

  // Function to submit data
  Future<void> _nextQuestion(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Convert DateTime to a string in 'yyyy-MM-dd' format
      String? _formattedAttackDate = date != null
          ? DateFormat('yyyy-MM-dd').format(date!)
          : null;

      // Prepare the payload for API request
      Map<String, dynamic> dataToSend = {
        "attacker": {
          "species": widget.attacker['species'].toString(),
          "age": widget.attacker['age'].toString(),
          "sex": widget.attacker['sex'].toString(),
          "breed": widget.attacker['breed'].toString(),
          "vaccinationStatus": widget.attacker['vaccinationStatus'].toString(),
          "status": widget.attacker['status'].toString(),
          "lastVaccinatedOn": widget.attacker['lastVaccinatedOn'] is DateTime
              ? DateFormat('yyyy-MM-dd').format(widget.attacker['lastVaccinatedOn'])
              : widget.attacker['lastVaccinatedOn'],
        },
        "victim": {
          "species": widget.victim['species'].toString(),
          "age": widget.victim['age'].toString(), // Converted age to string
          "sex": widget.victim['gender'].toString(),
          "breed": widget.victim['breed'].toString(),
          "vaccinationStatus": widget.victim['vaccinationStatus'].toString(),
          "boosterVaccination": widget.victim['boosterVaccination'],
          "vaccinationDose": dose, // Use the selected dose
          "biteSite": widget.victim['attackSite'].toString(),
          "woundCategory": widget.victim['woundCategory'],
          //"firstAidGiven": widget.victim['firstAidGiven'].toString(), // Converted firstAidGiven to string
        },
        "victimOwner": {
           "name": widget.owner['name'].toString(),
           "address": widget.owner['address'].toString(),
           "mobile": widget.owner['mobile'].toString(),
        },
        "district": widget.doctor['district'].toString(),
        "area": widget.victim['area'].toString(), // Converted area to string
        "doctorId": widget.doctor['doctorId'].toString(),
        "attackDate": widget.victim['attackDate'] is DateTime
            ? DateFormat('yyyy-MM-dd').format(widget.victim['attackDate'])
            : widget.victim['attackDate'].toString(),
        "dose": dose,
        "date": _formattedAttackDate,
      };

      // Print the data as JSON (with double quotes visible)
      String jsonData = jsonEncode(dataToSend);
      print(jsonData); // This will show the proper JSON format with double quotes

      // Sending the modified data
      try {
        final formattedToken = widget.jwtToken.trim();
        final url = Uri.parse('https://rabitrack-backend-production.up.railway.app/addNewCase');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'jwttoken=$formattedToken',
          },
          body: jsonEncode(dataToSend),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessPage(doctor: widget.doctor, jwtToken: widget.jwtToken),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit data: ${response.body}')));
          print(response.body);
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error occurred: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Full-screen background image
          Image.asset(
            'assets/bg.jpeg',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Centered content on top of the background image
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.grey[300]?.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey, // Attach the GlobalKey to the form
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Page title
                      Text(
                        'Actions Taken',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Dropdown for number of doses
                      Text(
                        'Number of doses given?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<int>(
                        dropdownColor: Colors.grey[700],
                        value: dose,
                        items: [0, 3, 7, 14, 28, 90].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              '$value doses',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            dose = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Date picker for dose date
                      Text(
                        'Date doses were given',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              date = pickedDate;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            date != null
                                ? "${date!.day}/${date!.month}/${date!.year}"
                                : "Select Date",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

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
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
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
  final Map<String, dynamic> doctor;
  final String jwtToken;
  SuccessPage({required this.doctor,required this.jwtToken,});

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
                      settings: RouteSettings(
                        arguments: {
                          'doctorName': widget.doctor['doctorName'],
                          'doctorId': widget.doctor['doctorId'],
                          'area': widget.doctor['area'] ?? 'Unknown', // Assuming area and district are available
                          'district': widget.doctor['district'] ?? 'Unknown',
                          'jwtToken': widget.jwtToken,
                        },
                      ),
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