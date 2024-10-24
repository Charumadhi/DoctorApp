import 'dart:convert';  // For encoding JSON objects

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class AttackerDetailsPage extends StatefulWidget {

  final Map<String, dynamic> doctor;
  final Map<String, dynamic> victim;
  final String jwtToken;

  const AttackerDetailsPage({
    Key? key,
    required this.doctor,
    required this.victim,
    required this.jwtToken,
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
  String? _species;
  String? _breed;
  String? _age;
  String? _vaccinationStatus; // tinyint in the backend (true/false)
  String? _animalCondition;
  String? _gender;
  //int? _pincode;
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
        'condition': _animalCondition,
        // 'pincode': _pincode,
      };
      print("Moving to first question page");

      // Print both maps to the terminal
      // Print all details of the doctor map
      print('Doctor Details:');
      widget.doctor.forEach((key, value) {
        print('$key: $value');
      });

// Print all details of the victim map
      print('Victim Details:');
      widget.victim.forEach((key, value) {
        print('$key: $value');
      });

      print('Attacker Details: $attacker');


      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FirstQuestionPage(
          doctor: widget.doctor,
          victim: widget.victim,
          attacker: attacker,
          jwtToken: widget.jwtToken,
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
  Widget _buildTextField(String label, ValueChanged<String> onChanged, {String? initialValue, String? Function(String?)? validator,TextInputType? keyboardType,}) {
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

              _buildDropdownField(
                'What kind of species is it?',
                _species,
                ['Dog', 'Cat', 'Goat', 'Cattle', 'Poultry'], // List of species options
                    (value) => setState(() => _species = value),
              ),
              const SizedBox(height: 20),


          // Variable to hold the combined breed value


// Dropdown for breed selection
          _buildDropdownField(
          'What kind of breed is it?',
          _combinedBreed, // Use the combined breed variable
          ['Pure breed', 'Cross bred', 'Non-Descript (specify)'], // List of breed options
              (value) {
            setState(() {
              // Update the combined breed variable
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
              // Update combined breed with specified value
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
                  _buildTextField(
                    'How old is that species?',
                        (value) {
                      setState(() {
                        _age = value;
                      });
                    },
                    //keyboardType: TextInputType.number,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter age';
                    //   }
                    //   int? age = int.tryParse(value);
                    //   if (age == null || age <= 0) {
                    //     return 'Please enter a valid number above 0';
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 20),
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
              const SizedBox(height: 20),

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

              _buildDropdownField(
                'How is it now?',
                _animalCondition,
                ['Natural Death', 'Dead with Rabies Symptoms', 'Alive with No Symptoms'],
                    (value) => setState(() => _animalCondition = value),
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
                  backgroundColor: Colors.blue,
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
  final String jwtToken;

  FirstQuestionPage({required this.doctor, required this.victim, required this.attacker, required this.jwtToken});

  @override
  _FirstQuestionPageState createState() => _FirstQuestionPageState();
}

class _FirstQuestionPageState extends State<FirstQuestionPage> {
  // Define bools for each checkbox
  bool woundWashing = false;
  bool appliedTurmeric = false;
  bool suturedWound = false;
  bool appliedOintment = false;

  // Variable for vaccination dose dropdown
  int? vaccinationDose; // Default value of dose to 0

  // Function to submit data
  Future<void> _nextQuestion(BuildContext context) async {
    // Prepare the first aid status as a comma-separated string
    String firstAidGiven = '';

    if (woundWashing) firstAidGiven += "Wound washing done, ";
    if (appliedTurmeric) firstAidGiven += "Applied turmeric/chilli powder on the wound, ";
    if (suturedWound) firstAidGiven += "Sutured the wound, ";
    if (appliedOintment) firstAidGiven += "Applied ointment on the wound, ";

    // Remove the trailing comma and space
    if (firstAidGiven.isNotEmpty) {
      firstAidGiven = firstAidGiven.substring(0, firstAidGiven.length - 2);
    }

    // Update victim with the first aid status
    widget.victim['firstAidGiven'] = firstAidGiven;
    // Add vaccination dose to the victim if vaccination status is true
    if (widget.victim['vaccinationStatus'] == 'Vaccinated') {
      widget.victim['vaccinationDose'] = vaccinationDose;
    }

    // Prepare the payload for API request
    // Prepare the payload for API request
    Map<String, dynamic> dataToSend = {
      "attacker": {
        "species": widget.attacker['species'].toString(),
        "age": widget.attacker['age'].toString(),
        "sex": widget.attacker['sex'].toString(),
        "breed": widget.attacker['breed'].toString(),
        "vaccinationStatus": widget.attacker['vaccinationStatus'].toString(),
        "condition": widget.attacker['condition'].toString(),
      },
      "victim": {
        "species": widget.victim['species'].toString(),
        "age": widget.victim['age'].toString(),  // Converted age to string
        "sex": widget.victim['gender'].toString(),
        "breed": widget.victim['breed'].toString(),
        "vaccinationStatus": widget.victim['vaccinationStatus'].toString(),
        "boosterVaccination": widget.victim['boosterVaccination'],
        "vaccinationDose": widget.victim['vaccinationDose'],
        "biteSite": widget.victim['attackSite'].toString(),
        "woundCategory": widget.victim['woundCategory'],
        "firstAidGiven": widget.victim['firstAidGiven'].toString(), // Converted firstAidGiven to string
      },
      "district": widget.doctor['district'].toString(),
      "pincode": widget.victim['pincode'], // Converted pincode to string
      "doctorId": widget.doctor['doctorId'].toString(),
      "attackDate": widget.victim['attackDate'].toString(),
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
        headers: {'Content-Type': 'application/json', 'Cookie': 'jwttoken=${formattedToken}',},
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.grey[300]?.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
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

                    // Check if vaccinationStatus is true to show the dropdown
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
                        value: vaccinationDose,
                        items: [0, 3, 7, 14, 28].map((int value) {
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
                            vaccinationDose = newValue ?? 0;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                    // Four checkboxes for first aid options
                    CheckboxListTile(
                      title: Text("Wound washing done", style: TextStyle(color: Colors.white)),
                      value: woundWashing,
                      onChanged: (bool? value) {
                        setState(() {
                          woundWashing = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Applied turmeric/chilli powder on the wound", style: TextStyle(color: Colors.white)),
                      value: appliedTurmeric,
                      onChanged: (bool? value) {
                        setState(() {
                          appliedTurmeric = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Sutured the wound", style: TextStyle(color: Colors.white)),
                      value: suturedWound,
                      onChanged: (bool? value) {
                        setState(() {
                          suturedWound = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Applied any ointment on the wound", style: TextStyle(color: Colors.white)),
                      value: appliedOintment,
                      onChanged: (bool? value) {
                        setState(() {
                          appliedOintment = value ?? false;
                        });
                      },
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