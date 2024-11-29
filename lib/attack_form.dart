import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
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
  String? _age=''; // tinyint in the backend
  String? _gender; // char in the backend
  String? _attackSite;
  String? _woundCategory; // smallint in the backend
  String? _vaccinationStatus;  // No selection by default (nullable)
  bool? _boosterVaccination = null;  // No selection by default (nullable)
  //int? _pincode; // int in the backend
  String? _breedDescription;
  String? _speciesDescription;
  String? _district;
  String? name;
  String? address;
  String? mobile;
  String? _woundSeverity;
  DateTime? lastVaccinatedOn;


  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _woundController = TextEditingController();
  // For manual input of wound category
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
  @override
  void dispose() {
    _dateController.dispose();
    _woundController.dispose();
    _areaController.dispose();
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
        'species': _species == 'others(specify)'
            ? 'others: $_speciesDescription'
            : _species,
        'breed': _breed,
        'age': _age,
        'gender': _gender == 'Unknown' ? null : _gender,
        'attackSite': _attackSite,
        'woundCategory': _woundCategory,
        'woundSeverity': _woundSeverity,
        'vaccinationStatus': _vaccinationStatus,
        'boosterVaccination': _boosterVaccination,
        'district': _district,
        'lastVaccinatedOn': lastVaccinatedOn, // Store the vaccinated date
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
  Widget _buildManualEntryField(String label, TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
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
    final Map<String, List<String>> districtAreaMap = {
      "Puducherry": [
        "White Town",
        "Auroville",
        "Lawspet",
        "Reddiarpalayam",
        "Anna Nagar",
        "Nellithope",
        "Muthialpet",
        "Karuvadikuppam",
        "Kottakuppam",
        "Ariyankuppam",
        "Thattanchavady",
        "Rainbow Nagar",
        "Villianur",
        "Mudaliarpet",
        "Kalapet",
        "Kanakachettikulam"
      ],
      "Karaikal": [
        "Karaikal Town",
        "Thirunallar",
        "Kottucherry",
        "Neravy",
        "Keezhakasakudy",
        "Tirumalairayanpattinam",
        "Kilinjalmedu",
        "Dharmapuram",
        "Polagam",
        "Poovam",
        "Karaikalmedu",
      ],
      "Mahe": [
        "Mahe Town",
        "Palloor",
        "Pandakkal",
        "Cherukallayi",
        "Manjakkal",
        "Naluthara",
        "Chalakkara"
      ],
      "Yanam": [
        "Yanam Town",
        "Mettakur",
        "Savithri Nagar",
        "Kanakalapeta",
        "Agraharam",
        "Venkanna Babu Nagar",
        "Farampeta"
      ],
      "Tamil Nadu": []
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('Victim', style: TextStyle(color: Colors.white)), // Title color
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
                _buildDropdownField(
                  'District',
                  _district,
                  districtAreaMap.keys.toList(),
                      (value) {
                    setState(() {
                      _district = value!;
                      _area = null; // Reset area selection when district changes
                      _areaController.clear();
                    });
                  },
                ),
                const SizedBox(height: 20),
                if (_district != null)
                  (_district == "Tamil Nadu")
                      ? _buildManualEntryField(
                      "Area", _areaController, "Enter the area in Tamil Nadu")
                      : _buildDropdownField(
                    'Area',
                    _area,
                    districtAreaMap[_district]!,
                        (value) {
                      setState(() {
                        _area = value!;
                      });
                    },
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
                    'Dog', 'Cat', 'Goat', 'Cattle', 'Poultry', 'Sheep', 'others(specify)'
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
                validator: (value) {
                if (value == null || value.isEmpty) {
                return 'Please enter the breed type';
                }
                return null;
                },
                ),


                const SizedBox(height: 20),
                Text(
                  'Age: $_age', // Display the concatenated age
                  style: TextStyle(fontSize: 18),
                ),




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
                // Display concatenated age directly

                _buildDropdownField(
                  'What gender is it?',
                  _gender,
                  ['M', 'F', 'Unknown'],
                      (value) {
                    setState(() {
                      // Store 'Unknown' as null in _gender
                      _gender = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildDropdownField('Bite Site', _attackSite, ['Head', 'Trunk', 'Forelimb', 'Hindlimb'], (value) {
                  setState(() {
                    _attackSite = value;
                  });
                }),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _woundCategory,  // Remain null until user selection
                  items: ['1', '2', '3','4']
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
                  value: _woundSeverity,  // Remain null until user selection
                  items: ['Severe', 'Moderate', 'Mild']
                      .map((woundSeverity) => DropdownMenuItem<String>(
                    value: woundSeverity,
                    child: Text(woundSeverity),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _woundSeverity = value;  // Store selected value as a string
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Wound Severity',
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
    _vaccinationStatus = value;
    if (_vaccinationStatus != 'Vaccinated') {
    lastVaccinatedOn = null; // Reset the date if not vaccinated
    }
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

                if (_vaccinationStatus == 'Vaccinated') ...[
                  // Booster Vaccination Dropdown
                  DropdownButtonFormField<String>(
                    value: _boosterVaccination == null ? null : (_boosterVaccination == true ? 'Taken' : 'Not Taken'),
                    items: [
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
                        _boosterVaccination = value == 'Taken';
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

                  // Styled Vaccination Date Selection
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
                ],
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
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.length != 10) {
                      return 'Enter a valid mobile number';
                    }
                    return null; // Valid input
                  },
                ),
                const SizedBox(height: 20),
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
        String? Function(String?)? validator,
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
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null; // Valid input
      },
      maxLength: keyboardType == TextInputType.phone ? 10 : null, // Limit input to 10 for phone
      inputFormatters: keyboardType == TextInputType.phone
          ? [FilteringTextInputFormatter.digitsOnly] // Allow only digits for phone
          : [], // No specific input formatter for text
    );
  }

}