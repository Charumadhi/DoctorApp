import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date
import 'attacker_details.dart';
import 'profile_page.dart';
import 'package:doctor_app/statistics.dart';

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Attack Form',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: AttackFormPage(),
//     );
//   }
// }

class AttackFormPage extends StatefulWidget {

  final String doctorId;
  final String doctorName;
  final String area;
  final String district;

  AttackFormPage({
    required this.doctorId,
    required this.doctorName,
    required this.area,
    required this.district,
  });

  @override
  _AttackFormPageState createState() => _AttackFormPageState();
}

class _AttackFormPageState extends State<AttackFormPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _area;
  String? _species;
  String? _breed;
  int? _age;
  String _ageUnit = 'Years'; // Default unit is 'Years'
  String? _gender;
  String? _attackSite;
  String? _woundCategory;
  String? _vaccinationStatus;
  String? _vaccinationDetail;
  String? _numberOfDoses;

  int _selectedIndex = 0; // Keeps track of the current tab index

  // Function that handles navigation based on the tapped tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 2) {
      // Profile button tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to ProfilePage
      );
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Navigate to the Attacker Details page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AttackerDetailsPage()),
      );
    }
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date of Attack',
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            _selectDate(context);
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8), // Slightly transparent background
      ),
      controller: TextEditingController(
        text: _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : '',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        } else {
          DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(value);
          if (selectedDate.isAfter(DateTime.now())) {
            return 'Please enter a valid date. Future dates are not allowed.';
          }
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8), // Slightly transparent background
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
        title: const Text('New Attack'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Victim Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // Date of Attack
                _buildDateField(context),
                const SizedBox(height: 20),

                // Area dropdown
                _buildDropdownField('Area', _area, ['Puducherry', 'Karaikal', 'Mahe', 'Yanam'], (value) {
                  setState(() {
                    _area = value;
                  });
                }),
                const SizedBox(height: 20),

                // Species dropdown
                _buildDropdownField('What kind of animal is it?', _species, ['Dog', 'Cattle', 'Cat'], (value) {
                  setState(() {
                    _species = value;
                  });
                }),
                const SizedBox(height: 20),

                // Breed dropdown
                _buildDropdownField('What kind of breed is it?', _breed, ['Pure Breed', 'Cross Breed', 'Unable to Specify'], (value) {
                  setState(() {
                    _breed = value;
                  });
                }),
                const SizedBox(height: 20),

                // Age of Species
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'How old is that species?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15), // Rounded corners
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8), // Slightly transparent background
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
                            _age = int.tryParse(value);
                          });
                        },
                      ),
                    ),
                    // const SizedBox(width: 10),
                    // Expanded(
                    //   child: DropdownButtonFormField<String>(
                    //     value: _ageUnit,
                    //     decoration: InputDecoration(
                    //       labelText: 'Unit',
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(15), // Rounded corners
                    //       ),
                    //       filled: true,
                    //       fillColor: Colors.white.withOpacity(0.8), // Slightly transparent background
                    //     ),
                    //     items: <String>['Months', 'Years']
                    //         .map<DropdownMenuItem<String>>((String value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value),
                    //       );
                    //     }).toList(),
                    //     onChanged: (String? newValue) {
                    //       setState(() {
                    //         _ageUnit = newValue!;
                    //       });
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),

                // Gender dropdown
                _buildDropdownField('What gender is it?', _gender, ['Male', 'Female'], (value) {
                  setState(() {
                    _gender = value;
                  });
                }),
                const SizedBox(height: 20),

                // Attack site dropdown
                _buildDropdownField('Where was it attacked?', _attackSite, [
                  'Extremities of Body',
                  'Hip region',
                  'Neck region',
                  'Chest region'
                ], (value) {
                  setState(() {
                    _attackSite = value;
                  });
                }),
                const SizedBox(height: 20),

                // Wound category dropdown
                _buildDropdownField('How far is the wound?', _woundCategory, ['1', '2', '3', 'More than 3'], (value) {
                  setState(() {
                    _woundCategory = value;
                  });
                }),
                const SizedBox(height: 20),

                // Vaccination status dropdown
                _buildDropdownField('Do you know its Vaccination Status?', _vaccinationStatus, ['Known', 'Unknown'], (value) {
                  setState(() {
                    _vaccinationStatus = value;
                  });
                }),
                const SizedBox(height: 20),

                // Conditional Vaccination Details dropdown
                if (_vaccinationStatus == 'Known') ...[
                  _buildDropdownField('Vaccination Details', _vaccinationDetail, ['Vaccinated', 'Not Vaccinated'], (value) {
                    setState(() {
                      _vaccinationDetail = value;
                    });
                  }),
                  const SizedBox(height: 20),
                  _buildDropdownField('How many doses has it had?', _numberOfDoses, ['1', '2', '3', 'More than 3'], (value) {
                    setState(() {
                      _numberOfDoses = value;
                    });
                  }),
                  const SizedBox(height: 20),
                ],

                // Submit button
                Center(
                  child: ElevatedButton(
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
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      // BottomNavigationBar for navigation
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
