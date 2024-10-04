import 'package:flutter/material.dart';

class AttackerDetailsPage extends StatefulWidget {
  @override
  _AttackerDetailsPageState createState() => _AttackerDetailsPageState();
}

class _AttackerDetailsPageState extends State<AttackerDetailsPage> {
  String? _animalOwnership;
  String? _animalType;
  String? _animalAge;
  String? _vaccinationStatus;
  String? _vaccinationState;
  String? _animalCondition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Attack'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView( // Wrap the body in SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title for Attacker's Details
            Text(
              'Attacker\'s Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Animal Ownership Dropdown
            DropdownButtonFormField<String>(
              value: _animalOwnership,
              decoration: InputDecoration(
                labelText: 'Do you know what Animal it is?',
                border: OutlineInputBorder(),
                hintText: 'Select Category',
                hintStyle: TextStyle(color: Colors.purple),
              ),
              items: ['Owned', 'Stray']
                  .map((ownership) => DropdownMenuItem<String>(
                value: ownership,
                child: Text(ownership),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _animalOwnership = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Animal Type Dropdown
            DropdownButtonFormField<String>(
              value: _animalType,
              decoration: InputDecoration(
                labelText: 'What Kind of Animal it is?',
                border: OutlineInputBorder(),
                hintText: 'Select Species',
                hintStyle: TextStyle(color: Colors.purple),
              ),
              items: ['Dog', 'Cattle', 'Cat']
                  .map((type) => DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _animalType = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Animal Age Input
            TextField(
              decoration: InputDecoration(
                labelText: 'How old is that Species?',
                border: OutlineInputBorder(),
                hintText: 'Enter value',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _animalAge = value;
              },
            ),
            const SizedBox(height: 20),

            // Vaccination Status Dropdown
            DropdownButtonFormField<String>(
              value: _vaccinationStatus,
              decoration: InputDecoration(
                labelText: 'Do you know its Vaccination Status?',
                border: OutlineInputBorder(),
                hintText: 'Select Vaccination Status',
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

            // Conditional Vaccination State Dropdown
            if (_vaccinationStatus == 'Known')
              DropdownButtonFormField<String>(
                value: _vaccinationState,
                decoration: InputDecoration(
                  labelText: 'Select Vaccination Status',
                  border: OutlineInputBorder(),
                  hintText: 'Select Status',
                  hintStyle: TextStyle(color: Colors.purple),
                ),
                items: ['Vaccinated', 'Not Vaccinated']
                    .map((state) => DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _vaccinationState = value;
                  });
                },
              ),
            const SizedBox(height: 20),

            // Animal Condition Dropdown
            DropdownButtonFormField<String>(
              value: _animalCondition,
              decoration: InputDecoration(
                labelText: 'How is it now?',
                border: OutlineInputBorder(),
                hintText: 'Condition of the Animal',
                hintStyle: TextStyle(color: Colors.purple),
              ),
              items: ['Natural Death', 'Dead with Rabies Symptoms', 'Alive with No Symptoms']
                  .map((condition) => DropdownMenuItem<String>(
                value: condition,
                child: Text(condition),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _animalCondition = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Handle the submission logic here
                // You can also display a success message or navigate to another page
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),

    );
  }
}
