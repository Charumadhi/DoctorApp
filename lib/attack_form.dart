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
  String? _breed = 'Pure Breed';
  int? _age;

  String? _gender = 'Male';
  String? _attackSite = 'Extremities of Body';
  String? _woundCategory = '1';
  String? _vaccinationStatus = 'Known';
  String? _vaccinationDetail = 'Vaccinated';
  String? _numberOfDoses = '1';

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
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Enable scrolling
          child: Form(
            key: _formKey,
            child: Column( // Use Column instead of ListView
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
                    hintText: 'Enter value',
                    hintStyle: TextStyle(color: Colors.purple),
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
                    hintText: 'Select Area',
                    hintStyle: TextStyle(color: Colors.purple),
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
                    hintText: 'Select Species',
                    hintStyle: TextStyle(color: Colors.purple),
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
                    hintText: 'Select Breed Type',
                    hintStyle: TextStyle(color: Colors.purple),
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
                    hintText: 'Enter age',
                    hintStyle: TextStyle(color: Colors.purple),
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
                    hintText: 'Select Sex',
                    hintStyle: TextStyle(color: Colors.purple),
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
                    hintText: 'Select Site of Dog bite in the body',
                    hintStyle: TextStyle(color: Colors.purple),
                  ),
                  items: [
                    'Extremities of Body',
                    'Hip region',
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
                    hintText: 'Select Category of the Wound',
                    hintStyle: TextStyle(color: Colors.purple),
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
                    hintText: 'Select Vaccination State',
                    hintStyle: TextStyle(color: Colors.purple),
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

                // If vaccination status is known, select status
                if (_vaccinationStatus == 'Known') ...[
                  DropdownButtonFormField<String>(
                    value: _vaccinationDetail,
                    decoration: InputDecoration(
                      labelText: 'Select Status',
                      border: OutlineInputBorder(),
                      hintText: 'Select Vaccination Status',
                      hintStyle: TextStyle(color: Colors.purple),
                    ),
                    items: ['Vaccinated', 'Not Vaccinated']
                        .map((status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _vaccinationDetail = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Number of Doses
                  DropdownButtonFormField<String>(
                    value: _numberOfDoses,
                    decoration: InputDecoration(
                      labelText: 'How many Doses?',
                      border: OutlineInputBorder(),
                      hintText: 'Select Doses',
                      hintStyle: TextStyle(color: Colors.purple),
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
                ],
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process the data
                      print('Form submitted!');
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
