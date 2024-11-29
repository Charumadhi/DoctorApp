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
  int? _selectedDose;

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
    final dose = _selectedDose;
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
            mainAxisSize: MainAxisSize.min, // Add this line
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionHeader('Attacker Details'),
              buildDetailCard(caseDetails!['attacker'],includeAttackArea: true),
              SizedBox(height: 24),
              buildSectionHeader('Victim Details'),
              buildDetailCard(caseDetails!['victim']),
              SizedBox(height: 24),
              buildSectionHeader('Owner Details'),
              buildDetailCard(caseDetails!['owner']),
              SizedBox(height: 24),
              buildDoseSection(),

              SizedBox(height: 24),

              SizedBox(height: 40), // Ensure there's extra space at the bottom
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
  Widget buildDoseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader('Dose Details'),
        const SizedBox(height: 10), // Add some spacing between the header and the button
        ElevatedButton(
          onPressed: _showUpdateDoseDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Background color
            foregroundColor: Colors.white, // Text color // Text color
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            elevation: 5, // Elevation for shadow
          ),
          child: Text(
            'Update Dose',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10), // Add spacing after the button
        buildDoseDetails(caseDetails!['doseDetails']),
      ],
    );
  }

  Widget buildDetailCard(Map<String, dynamic>? details, {bool includeAttackArea = false}) {
    details?.forEach((key, value) {
      print('$key: $value');
    });

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
        children: [
          if (includeAttackArea) buildInfoRow('Attack area', caseDetails!['district'] ?? 'Unknown'),
          ...details?.entries.map((entry) {
            if (entry.key == 'attacker_id' || entry.key == 'victim_id') {
              return SizedBox.shrink(); // Skip attacker_id and victim_id
            }

            String displayValue = (entry.value == null || entry.value.toString().isEmpty || entry.value.toString().toLowerCase() == 'null')
                ? 'Unknown'
                : entry.value.toString();

            // Check vaccination status and last vaccinated date
            if (entry.key == 'vaccination_status') {
              print('Vaccination Status: $displayValue');
              return buildInfoRow('Vaccination Status', displayValue);
            } else if (entry.key == 'last_vaccinated_on') {
              String vaccinationStatus = details['vaccination_status'] ?? 'Unknown';
              print('Last Vaccinated On: $displayValue, based on Vaccination Status: $vaccinationStatus');

              if (vaccinationStatus.toLowerCase() == 'not vaccinated' ||
                  vaccinationStatus.toLowerCase() == 'unknown' ||
                  vaccinationStatus.isEmpty || vaccinationStatus.toLowerCase() == 'null' || vaccinationStatus.toLowerCase() == 'not known') {
                return SizedBox.shrink(); // Skip displaying last_vaccinated_on
              } else {
                return buildInfoRow('Last Vaccinated On', displayValue);
              }
            }

            // For other fields
            if (entry.key == 'sex') {
              displayValue = _mapSex(entry.value) ?? 'Unknown';
            }
            if (entry.key == 'is_pet') {
              displayValue = entry.value == 1 ? 'Yes' : 'No';
            }

            return buildInfoRow(entry.key.replaceAll('_', ' '), displayValue);
          }).toList() ?? [],
        ],
      ),
    );
  }


  String _mapSex(String? sex) {
    switch (sex) {
      case 'M':
        return 'Male';
      case 'F':
        return 'Female';
      case 'Unknown':
        return 'Unknown';
      default:
        return 'Not Specified';
    }
  }
  String getDoseWithSuffix(int dose) {
    if (dose % 10 == 1 && dose % 100 != 11) {
      return "$dose st day";
    } else if (dose % 10 == 2 && dose % 100 != 12) {
      return "$dose nd day";
    } else if (dose % 10 == 3 && dose % 100 != 13) {
      return "$dose rd day";
    } else {
      return "$dose th day";
    }
  }
  Widget buildDoseDetails(List<dynamic> doseDetails) {
    return Column(
      children: doseDetails.map((dose) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInfoRow('Dose', getDoseWithSuffix(dose['dose'])),
              buildInfoRow('Date', dose['dose_date']),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildInfoRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value.toString()),
        ],
      ),
    );
  }

  void _showUpdateDoseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Dose'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            DropdownButtonFormField<int>(
            value: _selectedDose,
            items: [0, 3, 7, 14, 28, 90].map((int dose) {
              // Determine appropriate suffix for each value
              String suffix;
              if (dose % 10 == 1 && dose % 100 != 11) {
                suffix = "${dose}st day";
              } else if (dose % 10 == 2 && dose % 100 != 12) {
                suffix = "${dose}nd day";
              } else if (dose % 10 == 3 && dose % 100 != 13) {
                suffix = "${dose}rd day";
              } else {
                suffix = "${dose}th day";
              }

              return DropdownMenuItem<int>(
                value: dose,
                child: Text(
                  suffix, // Display as '0th day', '3rd day', etc.
                  style: TextStyle(color: Colors.black87),
                ),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                _selectedDose = newValue;
              });
            },
            decoration: InputDecoration(
              labelText: 'Dose',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.9),
            ),
          ),

          TextField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date (yyyy-MM-dd)'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (_selectedDate != null) {
                    _dateController.text = '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}';
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                updateDose();
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}