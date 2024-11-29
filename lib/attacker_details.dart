import 'dart:convert';  // For encoding JSON objects

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:RABI_TRACK/statistics.dart';
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
  String? _breedDescription;
  String? _speciesDescription;
  String? _age='';
  String? _vaccinationStatus; // tinyint in the backend (true/false)
  String? _animalCondition;
  String? _gender;
  //String? _combinedBreed;
  bool? _pet;

  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();

  void _updateAge() {
    String years = _yearsController.text;
    String months = _monthsController.text;

    // Concatenate years and months
    if (years.isNotEmpty && months.isNotEmpty) {
      _age = '$years years $months months';
    } else if (years.isNotEmpty) {
      _age = '$years years';
    } else if (months.isNotEmpty) {
      _age = '$months months';
    } else {
      _age = ''; // Reset if both fields are empty
    }

    // Debugging: print the age
    print('Concatenated Age: $_age');
  }
  void _submitForm(){

    if (_formKey.currentState?.validate() ?? false) {


      print("Form is valid, navigating to FirstQuestionPage");
      Map<String, dynamic> attacker = {
        'species': _species == 'others(specify)'
            ? 'others: $_speciesDescription'
            : _species,
        'age': _age,
        'sex': _gender == 'Unknown' ? null : _gender,
        'breed': _breed ,// Combined breed value here
        'vaccinationStatus': _vaccinationStatus,
        'status': _animalCondition,
        'lastVaccinatedOn': lastVaccinatedOn, // Store the vaccinated date
        'pet': _pet,
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
  void _selectVaccinatedDate(BuildContext context) async {
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
        title: const Text('Attacker', style: TextStyle(color: Colors.white)), // Title color
        backgroundColor: Colors.blue, // App bar background color
        iconTheme: const IconThemeData(color: Colors.white), // Back button color
      ),
          body: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
          gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          ),
          ),
          child: SingleChildScrollView(

        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Attacker\'s Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
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
                items: [
                  'Dog', 'Cat',  'Unknown', 'others(specify)'
                ].map((species) => DropdownMenuItem<String>(
                  value: species,
                  child: Text(species),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _species = value!;
                    // Clear species description if not others
                    if (_species != 'others(specify)') {
                      _speciesDescription = '';
                    }
                  });
                },
                hint: Text('Select species type'),
              ),

// Only show the text field if others is selected
              if (_species == 'others(specify)')
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Specify the species',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _speciesDescription = value;
                      });
                    },
                    validator: (value) {
                      if (_species == 'others(specify)' && (value == null || value.isEmpty)) {
                        return 'Please specify the species';
                      }
                      return null;
                    },
                  ),
                ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'What kind of breed is it?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                onChanged: (value) {
                  setState(() {
                    _breed = value; // Update the breed value with user input
                  });
                },
              ),


              //const SizedBox(height: 20),

              // "Is it your pet?" dropdown
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Is it a pet?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                value: _pet != null ? (_pet! ? 'Yes' : 'No') : null, // Display 'Yes' or 'No' based on _pet value
                items: ['Yes', 'No'].map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _pet = value == 'Yes'; // Set _pet to true if 'Yes' is selected, false if 'No' is selected
                  });
                },
                hint: Text('Select option'),
              ),
              const SizedBox(height: 20),

              // Dropdown for breed selection
              // _buildDropdownField(
              //   'What kind of breed is it?',
              //   _combinedBreed,
              //   ['Pure breed', 'Cross breed', 'Non-Descript (specify)'], // List of breed options
              //       (value) {
              //     setState(() {
              //       _combinedBreed = value;
              //     });
              //   },
              // ),
              // const SizedBox(height: 20),
              //
              // // Conditional text field for specifying breed
              // if (_combinedBreed == 'Non-Descript (specify)')
              //   TextFormField(
              //     decoration: InputDecoration(
              //       labelText: 'Specify the breed',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //       filled: true,
              //       fillColor: Colors.white.withOpacity(0.8),
              //     ),
              //     onChanged: (value) {
              //       setState(() {
              //         _combinedBreed = 'Non-Descript (specify): $value'; // Combine both values
              //       });
              //     },
              //     validator: (value) {
              //       if (_combinedBreed == 'Non-Descript (specify): $value' && (value == null || value.isEmpty)) {
              //         return 'Please specify the breed'; // Validation message
              //       }
              //       return null;
              //     },
              //   ),
              const SizedBox(height: 10),

              // Display concatenated age directly
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Age: $_age', // Display the concatenated age
                  style: TextStyle(fontSize: 18),
                ),
              ),
              // Age input field
              const SizedBox(height: 20),
              TextField(
                controller: _yearsController,
                decoration: InputDecoration(
                  labelText: 'Years',
                  hintText: 'Enter years',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _updateAge(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _monthsController,
                decoration: InputDecoration(
                  labelText: 'Months',
                  hintText: 'Enter months',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _updateAge(),
              ),

              const SizedBox(height: 20),
              // Gender selection
              _buildDropdownField(
                'What gender is it?',
                _gender,
                ['M', 'F', 'Unknown'],
                    (value) {
                  setState(() {
                    // Store 'Unknown' as null in _gender
                    _gender = value ;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Vaccination Status dropdown
              // Vaccination Status Dropdown
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
                    _vaccinationStatus = value;
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

// Conditionally display the date field if status is 'Vaccinated'
              if (_vaccinationStatus == 'Vaccinated')
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Vaccinated Date: ${lastVaccinatedOn != null ? "${lastVaccinatedOn!.day}/${lastVaccinatedOn!.month}/${lastVaccinatedOn!.year}" : "Not selected"}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _selectVaccinatedDate(context),
                        icon: Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.white, // Set icon color to white
                        ),
                        label: Text(
                          'Select Date',
                          style: TextStyle(color: Colors.white), // Set text color to white
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent, // Custom background color
                          foregroundColor: Colors.white, // Ensures white text and icon by default
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ],
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
  bool isLoading = false;
  // Variable for vaccination dose dropdown
  int? dose; // Default value of dose to null
  DateTime? date;

  List<int> getDoseOptions() {
    if (widget.victim['woundSeverity'] == 'Mild') {
      return [0, 3];
    } else if (widget.victim['woundSeverity'] == 'Moderate') {
      return [0, 3, 7, 14];
    } else  {
      return [0, 3, 7, 14, 28, 90];
    }
  }


  // Function to submit data
  Future<void> _nextQuestion(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));
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
          "sex": widget.attacker['sex'],
          "breed": widget.attacker['breed'].toString(),
          "vaccinationStatus": widget.attacker['vaccinationStatus'].toString(),
          "status": widget.attacker['status'].toString(),
          "lastVaccinatedOn": widget.attacker['lastVaccinatedOn'] is DateTime
              ? DateFormat('yyyy-MM-dd').format(widget.attacker['lastVaccinatedOn'])
              : widget.attacker['lastVaccinatedOn'],
          "isPet": widget.attacker['pet'],
        },
        "victim": {
          "species": widget.victim['species'].toString(),
          "age": widget.victim['age'].toString(), // Converted age to string
          "sex": widget.victim['gender'],
          "breed": widget.victim['breed'].toString(),
          "vaccinationStatus": widget.victim['vaccinationStatus'].toString(),
          //"boosterVaccination": widget.victim['boosterVaccination'],
          "vaccinationDose": dose, // Use the selected dose
          "biteSite": widget.victim['attackSite'].toString(),
          "woundCategory": widget.victim['woundCategory'],
          "woundSeverity": widget.victim['woundSeverity'].toString(),
          "lastVaccinatedOn": widget.victim['lastVaccinatedOn'] is DateTime
              ? DateFormat('yyyy-MM-dd').format(widget.victim['lastVaccinatedOn'])
              : widget.victim['lastVaccinatedOn'],
          //"firstAidGiven": widget.victim['firstAidGiven'].toString(), // Converted firstAidGiven to string
        },
        "victimOwner": {
          "name": widget.owner['name'].toString(),
          "address": widget.owner['address'].toString(),
          "mobile": widget.owner['mobile'].toString(),
        },
        "district": widget.victim['district'].toString(),
        "area": widget.victim['area'].toString(), // Converted area to string
        "doctorId": widget.doctor['doctorId'].toString(),
        "attackDate": widget.victim['attackDate'] is DateTime
            ? DateFormat('yyyy-MM-dd').format(widget.victim['attackDate'])
            : widget.victim['attackDate'].toString(),
        "dose": dose,
        "doseDate": _formattedAttackDate,
      };

      // Print the data as JSON (with double quotes visible)
      String jsonData = jsonEncode(dataToSend);
      print(jsonData); // This will show the proper JSON format with double quotes
      void resetDataFetchedStatus() {
        // Logic to reset the data fetched status
        setState(() {
          // Reset any relevant variables, for example:
          // needFetchData = true; // If you have a variable to track fetch status
          // or any other reset logic
        });
      }
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
          resetDataFetchedStatus();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessPage(doctor: widget.doctor, jwtToken: widget.jwtToken),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit data')));
          print(response.body);
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error occurred')));
      }
      setState(() {
        isLoading = false;
      });
    }
  }
  String getDaySuffix(int value) {
    if (value >= 11 && value <= 13) {
      return 'th';
    }
    switch (value % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          // Full-screen background image
          Image.asset(
            'assets/action.jpg',
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
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Dropdown for number of doses
                      Text(
                        'Number of doses given?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<int>(
                        dropdownColor: Colors.grey[700],
                        value: dose,
                        hint: Text(
                          'Select Dose',
                          style: TextStyle(color: Colors.grey), // Hint color
                        ),
                        items: getDoseOptions().map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              '$value${getDaySuffix(value)} day',
                              style: TextStyle(color: Colors.black87),
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
                          color: Colors.black87,
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
                    onPressed: isLoading ? null : () => _nextQuestion(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black12,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
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