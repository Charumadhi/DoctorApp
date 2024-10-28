import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'attacker_details.dart';
import 'profile_page.dart';

class AttackFormPage extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String area;
  final String district;
  final String jwtToken;

  AttackFormPage({
    required this.doctorId,
    required this.doctorName,
    required this.area,
    required this.district,
    required this.jwtToken,
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
  String? _age; // tinyint in the backend
  String? _gender; // char in the backend
  String? _attackSite;
  String? _woundCategory; // smallint in the backend
  String? _vaccinationStatus;  // No selection by default (nullable)
  bool? _boosterVaccination = null;  // No selection by default (nullable)
  //int? _pincode; // int in the backend
  String? _breedDescription;
  String? _district;
  String? name;
  String? address;
  String? mobile;


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
        MaterialPageRoute(builder: (context) => ProfilePage(jwtToken: widget.jwtToken)),
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
        'vaccinationStatus': _vaccinationStatus,
        'boosterVaccination': _boosterVaccination,
        'district': _district,
      };


      // Create a map to store the doctor details
      Map<String, dynamic> doctor = {
        'doctorId': widget.doctorId,
        'doctorName': widget.doctorName,
        'area': widget.area,
        'district': widget.district,
      };

      // Create a map to store the doctor details
      Map<String, dynamic> owner = {
        'name': name,
        'address': address,
        'mobile': mobile,
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
            jwtToken: widget.jwtToken,
            owner: owner,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a value';
        }
        return null;
      },
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
                _buildDropdownField('District', _district, ['Puducherry', 'Karaikal', 'Mahe', 'Yanam'], (value) {
                  setState(() {
                    _district = value;
                  });
                }),
                const SizedBox(height: 20),
                _buildTextField(
                  'Area',
                  null,
                  'Enter area',
                      (value) {
                    setState(() {
                      _area = value;
                    });
                  },
                  //keyboardType: TextInputType.number,
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
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'What kind of breed is it?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                  ),
                  value: _breed,
                  items: ['Pure breed', 'Cross breed', 'Non-Descript (specify)']
                      .map((breed) => DropdownMenuItem<String>(
                    value: breed,
                    child: Text(breed),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _breed = value!;
                      // Clear breed description if not Non-Descript
                      if (_breed != 'Non-Descript (specify)') {
                        _breedDescription = '';
                      }
                    });
                  },
                  hint: Text('Select breed type'),
                ),

                if (_breed == 'Non-Descript (specify)')
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0), // Add spacing
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Specify the breed',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _breedDescription = value;
                            // Combine both the selection and specified breed into _breed
                            _breed = 'Non-Descript (specify): $_breedDescription';
                          });
                        },
                        validator: (value) {
                          if (_breed == 'Non-Descript (specify)' &&
                              (value == null || value.isEmpty)) {
                            return 'Please specify the breed';
                          }
                          return null;
                        },
                      ),
                  ),

                const SizedBox(height: 20),
                _buildTextField(
                  'How old is that species?',
                  null,
                  'Enter age',
                      (value) {
                    setState(() {
                      _age = value;
                    });
                  },
                  //keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
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
                _buildDropdownField('Bite Site', _attackSite, ['Extremities of body', 'Hip region', 'chest region', 'neck and above', 'Head', 'Trunk', 'Forelimb', 'Hindlimb'], (value) {
                  setState(() {
                    _attackSite = value;
                  });
                }),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                      value: _woundCategory,  // Remain null until user selection
                      items: ['Severe', 'Moderate', 'Mild']
                         .map((woundSeverity) => DropdownMenuItem<String>(
                      value: woundSeverity,
                      child: Text(woundSeverity),
                  )).toList(),
                  onChanged: (value) {
                      setState(() {
                        _woundCategory = value;  // Store selected value as a string
                      });
                  },
                  decoration: InputDecoration(
                      labelText: 'Wound Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                  ),
               ),
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
                // Conditionally show the text field if the vaccination status is true
                if (_vaccinationStatus == 'Vaccinated')
                  DropdownButtonFormField<String>(
                    value: _boosterVaccination == null ? null : (_boosterVaccination == true ? 'Taken' : 'Not Taken'),  // Map boolean to string or null
                    items: [
                      // DropdownMenuItem<String>(
                      //   value: null,  // Placeholder value
                      //   child: Text('Select Vaccination Status'),  // Placeholder text
                      // ),
                      DropdownMenuItem<String>(
                        value: 'Taken',
                        child: Text('Taken'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Not Taken',
                        child: Text('Not Taken'),
                      ),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        if (value == null) {
                          _boosterVaccination = null;  // Reset to null if placeholder is selected
                        } else if (value == 'Taken') {
                          _boosterVaccination = true;  // Set boolean based on string
                        } else if (value == 'Not Taken') {
                          _boosterVaccination = false;
                        } else  {
                          _boosterVaccination = null;
                        }

                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Booster Vaccination Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),

                    ),
                  ),

                const SizedBox(height: 20),
                _buildTextField(
                  'Name of the owner',
                  null,
                  'Enter name',
                      (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  //keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  'Address of the owner',
                  null,
                  'Enter address',
                      (value) {
                    setState(() {
                      address = value;
                    });
                  },
                  //keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  'Mobile number of the owner',
                  null,
                  'Enter mobile no',
                      (value) {
                    setState(() {
                      mobile = value;
                    });
                  },
                  //keyboardType: TextInputType.number,
                ),
                // _buildTextField(
                //   'Enter your pincode',
                //   null,
                //   'Enter pincode',
                //       (value) {
                //     setState(() {
                //       _pincode = int.tryParse(value);
                //     });
                //   },
                //   keyboardType: TextInputType.number,
                // ),
                // const SizedBox(height: 30),
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