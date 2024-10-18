import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'attacker_details.dart';
import 'profile_page.dart';

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
  String? _gender; // char in the backend
  String? _attackSite;
  int? _woundCategory; // smallint in the backend
  bool _vaccinationStatus = false; // tinyint in the backend (true/false)
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
        'gender': _gender,
        'attackSite': _attackSite,
        'woundCategory': _woundCategory,
        'vaccinationStatus': _vaccinationStatus, // Now this will be true or false
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

      print('Doctor Details: $doctor');
      print('Victim Details: $victim');

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
        fillColor: Colors.white.withOpacity(0.9),
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

  Widget _buildDropdownField(String label, dynamic value, List<String> items, ValueChanged<dynamic> onChanged) {
    return DropdownButtonFormField<dynamic>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
      items: items.map((item) => DropdownMenuItem<dynamic>(
        value: item,
        child: Text(item),
      )).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Attack', style: TextStyle(color: Colors.white)), // Ensure color is consistent
        backgroundColor: Colors.blue,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Victim Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue), // Ensure color is consistent
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
                _buildTextField(
                  'What kind of species is it?',
                  _species,
                  'Enter species',
                      (value) {
                    setState(() {
                      _species = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  'What kind of breed is it?',
                  _breed,
                  'Enter breed',
                      (value) {
                    setState(() {
                      _breed = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  'How old is that species?',
                  null,
                  'Enter age',
                      (value) {
                    setState(() {
                      _age = int.tryParse(value);
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildDropdownField('What gender is it?', _gender, ['M', 'F'], (value) {
                  setState(() {
                    _gender = value;
                  });
                }),
                const SizedBox(height: 20),
                _buildTextField(
                  'Body part where it attacked?',
                  _attackSite,
                  'Enter attack site',
                      (value) {
                    setState(() {
                      _attackSite = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  'No. of wounds',
                  null,
                  'Enter number of wounds',
                      (value) {
                    setState(() {
                      _woundCategory = int.tryParse(value);
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildDropdownField('Vaccination Status', _vaccinationStatus ? 'Vaccinated' : 'Not Vaccinated', ['Vaccinated', 'Not Vaccinated'], (value) {
                  setState(() {
                    _vaccinationStatus = value == 'Vaccinated';
                  });
                }),
                const SizedBox(height: 20),
                _buildTextField(
                  'How many doses of vaccination?',
                  null,
                  'Enter number of doses',
                      (value) {
                    setState(() {
                      _numberOfDoses = int.tryParse(value);
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  'Enter your pincode',
                  null,
                  'Enter pincode',
                      (value) {
                    setState(() {
                      _pincode = int.tryParse(value);
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _buildTextField(
      String label,
      String? initialValue,
      String hint,
      ValueChanged<String> onChanged, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
