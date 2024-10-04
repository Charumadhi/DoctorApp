import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date

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
  int? _age;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Attack'),
        backgroundColor: Colors.red, // Optional: change color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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

              // Age of Species with integer input
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
              const SizedBox(height: 30),

              // Next Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process the form
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Form Submitted')),
                      );
                    }
                  },
                  child: Text('Next'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Set the button color to red
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Tab Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.red, // Highlight color for selected tab
      ),
    );
  }
}
