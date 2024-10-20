import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'case_details_page.dart';

class PastAttackReportsPage extends StatefulWidget {
  final String doctorId;
  final String jwtToken;

  const PastAttackReportsPage({Key? key, required this.doctorId,required this.jwtToken}) : super(key: key);

  @override
  _PastAttackReportsPageState createState() => _PastAttackReportsPageState();
}

class _PastAttackReportsPageState extends State<PastAttackReportsPage> {
  List<dynamic> attackReports = [];
  bool isLoading = true;
  String? errorMessage; // Variable to hold error messages

  @override
  void initState() {
    super.initState();
    fetchPastAttackReports();
  }

  Future<void> fetchPastAttackReports() async {
    final url = 'https://rabitrack-backend-production.up.railway.app/getCasesByDoctorId/${widget.doctorId}';

    try {
      final response = await http.get(Uri.parse(url),headers: {
        'Cookie': 'jwttoken=${widget.jwtToken}', // Include the jwtToken in the headers
      },);

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        setState(() {
          attackReports = decodedResponse;
          errorMessage = null; // Clear error if reports exist
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        // Handle the case where no reports are found
        setState(() {
          attackReports = []; // Clear any previous reports
          errorMessage = 'No past reports found'; // Update error message
          isLoading = false;
        });
      }
      else if (response.statusCode == 401) {
        // Handle unauthorized access
        setState(() {
          errorMessage = "User doesn't have permission";
          isLoading = false;
        });
      } else {
        // Handle other status codes (like 500)
        setState(() {
          errorMessage = 'Failed to load reports';
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle network errors
      setState(() {
        errorMessage = 'Failed to load reports';
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Top container with curved corners
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Center(
              child: Text(
                'Past Attack Reports',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (errorMessage == 'Failed to load reports') // Show retry button only on error
                    ElevatedButton(
                      onPressed: fetchPastAttackReports,
                      child: Text('Retry'),
                    ),
                ],
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: attackReports.length,
              itemBuilder: (context, index) {
                final report = attackReports[index];
                return GestureDetector(
                  onTap: () async {
                    // Navigate to CaseDetailsPage and wait for a result
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaseDetailsPage(caseId: report['case_id']),
                      ),
                    );

                    // If a case was deleted, refresh the attack reports
                    if (result == true) {
                      fetchPastAttackReports();
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 3), // Change position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${report['attack_date']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Aggressor: ${report['attacker_species']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey.shade700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Victim: ${report['victim_species']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey.shade500,
                          ),
                        ),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
