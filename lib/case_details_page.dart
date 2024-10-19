import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CaseDetailsPage extends StatefulWidget {
  final String caseId;

  const CaseDetailsPage({Key? key, required this.caseId}) : super(key: key);

  @override
  _CaseDetailsPageState createState() => _CaseDetailsPageState();
}

class _CaseDetailsPageState extends State<CaseDetailsPage> {
  Map<String, dynamic>? caseDetails;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchCaseDetails();
  }

  Future<void> fetchCaseDetails() async {
    final url = 'https://rabitrack-backend-production.up.railway.app/getCaseDetailsByCaseId/${widget.caseId}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          caseDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> deleteCase() async {
    final url = 'https://rabitrack-backend-production.up.railway.app/deleteCase/${widget.caseId}';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        // Case deleted successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Case deleted successfully')),
        );
        Navigator.pop(context, true); // Pass true to indicate deletion
      } else {
        // Handle error case here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete case')),
        );
      }
    } catch (e) {
      // Handle exceptions here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while deleting case')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white, // Set the text and icon color to white
        title: Text(
          'Case Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? Center(child: Text('Failed to load case details', style: TextStyle(color: Colors.red)))
          : caseDetails != null
          ? SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionHeader('Attacker Details'),
              buildDetailCard(caseDetails!['attacker'], true),
              SizedBox(height: 24),
              buildSectionHeader('Victim Details'),
              buildDetailCard(caseDetails!['victim'], false),
            ],
          ),
        ),
      )
          : Center(child: Text('No details available')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show confirmation dialog before deletion
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Delete Case'),
                content: Text('Are you sure you want to delete this case?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the dialog
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteCase(); // Call delete function
                      Navigator.of(context).pop(); // Dismiss the dialog
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
      ),
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

  Widget buildDetailCard(Map<String, dynamic>? details, bool isAttacker) {
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
          buildInfoRow('Species', details?['species']),
          buildInfoRow('Sex', details?['sex'] == 'M' ? 'Male' : details?['sex'] == 'F' ? 'Female' : 'N/A'),
          buildInfoRow('Breed', details?['breed']),
          buildInfoRow('Vaccination Status', details?['vaccination_status'] == 1 ? 'Yes' : 'No'),

          if (isAttacker) ...[
            buildMultilineInfoRow('Attacker Condition', details?['attacker_condition']),
            buildInfoRow('Attack Area', caseDetails!['pincode']),
            buildInfoRow('District', caseDetails!['district']),
          ],
          if (!isAttacker) ...[
            buildInfoRow('Vaccination Dose', details?['vaccination_dose']?.toString() ?? 'N/A'),
            buildInfoRow('Site of Bite', details?['site_of_bite'] ?? 'N/A'),
            buildInfoRow('Wound Category', details?['wound_category']?.toString() ?? 'N/A'),
            buildInfoRow('First Aid Status', details?['first_aid_status'] == 1 ? 'Yes' : 'No'),
          ],
        ],
      ),
    );
  }

  // For regular info rows
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
              textAlign: TextAlign.end, // Use TextAlign.end for right alignment
            ),
          ),
        ],
      ),
    );
  }

  // For multiline text fields like "Attacker Condition"
  Widget buildMultilineInfoRow(String label, dynamic value) {
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
              textAlign: TextAlign.end, // Align to the right side
            ),
          ),
        ],
      ),
    );
  }
}
