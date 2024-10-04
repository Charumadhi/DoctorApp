import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date
import 'attacker_details.dart';
import 'profile_page.dart';
import 'package:doctor_app/statistics.dart';
import 'package:doctor_app/profile_page.dart';
import 'package:doctor_app/home.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attack Form',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AttackFormPage(),
    );
  }
}

class AttackFormPage extends StatefulWidget {
  @override
  _AttackFormPageState createState() => _AttackFormPageState();
}

class _AttackFormPageState extends State<AttackFormPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _area = 'Puducherry';
  String? _species = 'Dog';
  String? _breed = 'Pure Breed';
  int? _age;
  String? _gender = 'Male';
  String? _attackSite = 'Extremities of Body';
  String? _woundCategory = '1';
  String? _vaccinationStatus = 'Known';
  String? _vaccinationDetail = 'Vaccinated';
  String? _numberOfDoses = '1';

  int _selectedIndex = 0; // Keeps track of the current tab index

  // Function that handles navigation based on the tapped tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 2) { // Profile button tapped
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Attack'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Victim Details heading
                Center(
                  child: Text(
                    'Victim Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // Date of Attack with calendar icon
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date of Attack',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text: _selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                        : '',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Area dropdown
                DropdownButtonFormField<String>(
                  value: _area,
                  decoration: InputDecoration(
                    labelText: 'Area',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Puducherry', 'Karaikal', 'Mahe', 'Yanam']
                      .map((area) => DropdownMenuItem<String>(
                    value: area,
                    child: Text(area),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _area = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Species dropdown
                DropdownButtonFormField<String>(
                  value: _species,
                  decoration: InputDecoration(
                    labelText: 'What kind of animal it is?',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Dog', 'Cattle', 'Cat']
                      .map((species) => DropdownMenuItem<String>(
                    value: species,
                    child: Text(species),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _species = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Breed Type dropdown
                DropdownButtonFormField<String>(
                  value: _breed,
                  decoration: InputDecoration(
                    labelText: 'What kind of breed it is?',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Pure Breed', 'Cross Breed', 'Unable to Specify']
                      .map((breed) => DropdownMenuItem<String>(
                    value: breed,
                    child: Text(breed),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _breed = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Age of Species
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'How old is that species? (Months/Years)',
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
                      _age = int.tryParse(value);
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Gender dropdown
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: InputDecoration(
                    labelText: 'What gender it is?',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Male', 'Female']
                      .map((gender) => DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Where it is attacked?
                DropdownButtonFormField<String>(
                  value: _attackSite,
                  decoration: InputDecoration(
                    labelText: 'Where it is attacked?',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    'Extremities of Body',
                    'Hip region',
                    'Neck region',
                    'Chest region'
                  ]
                      .map((site) => DropdownMenuItem<String>(
                    value: site,
                    child: Text(site),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _attackSite = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // How far the wound is?
                DropdownButtonFormField<String>(
                  value: _woundCategory,
                  decoration: InputDecoration(
                    labelText: 'How far the Wound is?',
                    border: OutlineInputBorder(),
                  ),
                  items: ['1', '2', '3', 'More than 3']
                      .map((category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _woundCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Vaccination Status
                DropdownButtonFormField<String>(
                  value: _vaccinationStatus,
                  decoration: InputDecoration(
                    labelText: 'Do you know its Vaccination Status?',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Known', 'Unknown']
                      .map((status) => DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _vaccinationStatus = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Vaccination Detail dropdown
                DropdownButtonFormField<String>(
                  value: _vaccinationDetail,
                  decoration: InputDecoration(
                    labelText: 'Vaccination Detail',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Vaccinated', 'Not Vaccinated']
                      .map((detail) => DropdownMenuItem<String>(
                    value: detail,
                    child: Text(detail),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _vaccinationDetail = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // No. of Vaccination Doses dropdown
                DropdownButtonFormField<String>(
                  value: _numberOfDoses,
                  decoration: InputDecoration(
                    labelText: 'How many doses it had?',
                    border: OutlineInputBorder(),
                  ),
                  items: ['1', '2', '3', 'More than 3']
                      .map((doses) => DropdownMenuItem<String>(
                    value: doses,
                    child: Text(doses),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _numberOfDoses = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Submit button
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
      // BottomNavigationBar for navigation
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
    onTap: (index) {
    if (index == 0) {
    // Navigate to HomePage
    Navigator.pushNamed(context, '/HomePage');
    } else if (index == 1) {
    // Navigate to HistoryPage
    Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsPage()));

    }
    else if (index == 2) {
      // Navigate to HistoryPage
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));

    }
    },
      ),
    );
  }
}
