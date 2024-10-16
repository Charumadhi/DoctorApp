import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'attacker_details.dart';
import 'profile_page.dart';
import 'package:doctor_app/statistics.dart';

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
  int? _age; // tinyint in the backend
  String _ageUnit = 'Years';
  String? _gender; // char in the backend
  String? _attackSite;
  int? _woundCategory; // smallint in the backend
  bool _vaccinationStatus = false; // tinyint in the backend (true/false)
  String? _vaccinationDetail;
  int? _numberOfDoses; // smallint in the backend
  int? _pincode; // int in the backend

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _woundController = TextEditingController(); // For manual input of wound category

  @override
  void dispose() {
    _dateController.dispose();
    _woundController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
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
      // Convert DateTime to a string in 'yyyy-MM-dd' format
      String? _formattedAttackDate = _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : null;

      // Create a map to store the victim details
      Map<String, dynamic> victim = {
        'attackDate': _formattedAttackDate,
        'area': _area,
        'species': _species,
        'breed': _breed,
        'age': _age,
        'ageUnit': _ageUnit,
        'gender': _gender,
        'attackSite': _attackSite,
        'woundCategory': _woundCategory,
        'vaccinationStatus': _vaccinationStatus ? 1 : 0, // Convert to tinyint
        'numberOfDoses': _numberOfDoses,
        'pincode': _pincode,
      };

      // Create a map to store the doctor details
      Map<String, dynamic> doctor = {
        'doctorId': widget.doctorId,
        'doctorName': widget.doctorName,
        'area': widget.area,
        'district': widget.district,
      };

      // Navigate to the Attacker Details page with both doctor and victim details
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttackerDetailsPage(
            doctor: doctor,
            victim: victim,
          ),
        ),
      );
    }
  }

  Widget _buildDateField(BuildContext context) {
    _dateController.text = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : '';

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
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
      ),
      controller: _dateController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(value);
        if (selectedDate.isAfter(DateTime.now())) {
          return 'Please enter a valid date. Future dates are not allowed.';
        }
        return null;
      },
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
                _buildDateField(context),
                const SizedBox(height: 20),
                _buildDropdownField('Area', _area, ['Puducherry', 'Karaikal', 'Mahe', 'Yanam'], (value) {
                  setState(() {
                    _area = value;
                  });
                }),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'What kind of species is it?',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _species = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the species';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'What kind of breed is it?',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _breed = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the breed';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'How old is that species?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter age';
                    }
                    int? age = int.tryParse(value);
                    if (age == null || age <= 0 || age > 127) {
                      return 'Please enter a valid age (1-127)';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _age = int.tryParse(value);
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildDropdownField('What gender is it?', _gender, ['M', 'F'], (value) {
                  setState(() {
                    _gender = value;
                  });
                }),
                const SizedBox(height: 20),
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
                // Replacing dropdown for wound category with a TextFormField for manual input
                TextFormField(
                  controller: _woundController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter the distance of the wound',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _woundCategory = int.tryParse(value); // Convert to int
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the wound distance';
                    }
                    int? woundDistance = int.tryParse(value);
                    if (woundDistance == null || woundDistance <= 0) {
                      return 'Please enter a valid wound distance';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildDropdownField('Vaccination Status', _vaccinationStatus ? '1' : '0', ['1', '0'], (value) {
                  setState(() {
                    _vaccinationStatus = value == '1'; // Convert to tinyint
                  });
                }),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'How many doses of vaccination?',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _numberOfDoses = int.tryParse(value); // For smallint
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter your pincode',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _pincode = int.tryParse(value); // For int
                    });
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Statistics'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDropdownField(String label, dynamic value, List<String> items, ValueChanged<dynamic> onChanged) {
    return DropdownButtonFormField<dynamic>(
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
          .map((item) => DropdownMenuItem<dynamic>(
        value: item,
        child: Text(item),
      ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
