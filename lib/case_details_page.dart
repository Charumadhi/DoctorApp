import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CaseDetailsPage extends StatefulWidget {
  final String caseId;
  final String jwtToken;

  const CaseDetailsPage({Key? key, required this.caseId, required this.jwtToken}) : super(key: key);

  @override
  _CaseDetailsPageState createState() => _CaseDetailsPageState();
}

class _CaseDetailsPageState extends State<CaseDetailsPage> {
  Map<String, dynamic>? caseDetails;
  bool isLoading = true;
  bool hasError = false;
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    fetchCaseDetails();
  }

  Future<void> fetchCaseDetails() async {
    final url = 'https://rabitrack-backend-production.up.railway.app/getCaseDetailsByCaseId/${widget.caseId}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Cookie': 'jwttoken=${widget.jwtToken}',
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            caseDetails = json.decode(response.body);
            print("Full backend response: ${caseDetails.toString()}");
            isLoading = false;
            hasError = false;
          });
        }
      } else {
        handleFetchError();
      }
    } catch (e) {
      handleFetchError();
    }
  }

  void handleFetchError() {
    if (mounted) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
    Future.delayed(Duration(seconds: 2), () {
      fetchCaseDetails();
    });
  }

  Future<void> deleteCase() async {
    final url = 'https://rabitrack-backend-production.up.railway.app/deleteCase/${widget.caseId}';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Cookie': 'jwttoken=${widget.jwtToken}',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Case deleted successfully')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete case')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while deleting case')),
      );
    }
  }

  Future<void> updateDose() async {
    final url = 'https://rabitrack-backend-production.up.railway.app/updateDoses/${widget.caseId}';
    final dose = int.tryParse(_doseController.text);
    final doseDate = _dateController.text;

    if (dose == null || doseDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid dose and date')),
      );
      return;
    }

    final data = json.encode({
      'dose': dose,
      'doseDate': doseDate,
    });

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'jwttoken=${widget.jwtToken}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dose updated successfully')),
        );
        setState(() {
          caseDetails?['doseDetails'] = [];  // Clear existing dose details
        });
        await fetchCaseDetails(); // Refresh the case details
        _doseController.clear(); // Clear the text fields
        _dateController.clear();
      } else {
        print('Failed to update dose: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update dose')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while updating dose')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          'Case Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? Center(
        child: Text(
          'Failed to load case details. Retrying...',
          style: TextStyle(color: Colors.red),
        ),
      )
          : caseDetails != null
          ? SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionHeader('Attacker Details'),
              buildDetailCard(caseDetails!['attacker']),
              SizedBox(height: 24),
              buildSectionHeader('Victim Details'),
              buildDetailCard(caseDetails!['victim']),
              SizedBox(height: 24),
              buildSectionHeader('Owner Details'),
              buildDetailCard(caseDetails!['owner']),
              SizedBox(height: 24),
              buildSectionHeader('Doctor Details'),
              buildDetailCard(caseDetails!['doctor']),
              SizedBox(height: 24),
              buildSectionHeader('Dose Details'),
              buildDoseDetails(caseDetails!['doseDetails']),
              buildInfoRow('District', caseDetails!['district']),
              SizedBox(height: 24),
              buildSectionHeader('Update Dose'),
              buildUpdateDoseButton(),
            ],
          ),
        ),
      )
          : Center(child: Text('No details available')),
      floatingActionButton: caseDetails != null
          ? FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Delete Case'),
                content: Text('Are you sure you want to delete this case?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteCase();
                      Navigator.of(context).pop();
                    },
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.delete),
      )
          : null,
    );
  }

  Widget buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget buildDetailCard(Map<String, dynamic>? details) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details?.entries.map((entry) => buildInfoRow(entry.key, entry.value))?.toList() ?? [],
      ),
    );
  }

  Widget buildDoseDetails(List<dynamic> doseDetails) {
    return Column(
      children: doseDetails.map((dose) {
        return Column(
          children: [
            buildInfoRow('Dose', dose['dose'] ?? 'N/A'),
            buildInfoRow('Dose Date', dose['doseDate'] ?? 'N/A'),
          ],
        );
      }).toList(),
    );
  }

  Widget buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$label:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value != null ? value.toString() : 'N/A',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUpdateDoseButton() {
    return ElevatedButton(
      onPressed: () {
        _showUpdateDoseDialog();
      },
      child: Text('Update Dose Details'),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
    );
  }

  Future<void> _showUpdateDoseDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Dose Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: _doseController,
                  decoration: InputDecoration(
                    labelText: 'Dose',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                        _dateController.text = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Date (yyyy-MM-dd)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                updateDose();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
