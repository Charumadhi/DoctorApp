import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'case_details_page.dart';

class PastAttackReportsPage extends StatefulWidget {
  final String doctorId;
  final String jwtToken;

  const PastAttackReportsPage({Key? key, required this.doctorId, required this.jwtToken}) : super(key: key);

  @override
  _PastAttackReportsPageState createState() => _PastAttackReportsPageState();
}

class _PastAttackReportsPageState extends State<PastAttackReportsPage> {
  List<dynamic> attackReports = [];
  List<dynamic> filteredReports = [];
  bool isLoading = true;
  bool isFilterEnabled = false; // Flag to control the display of the filter button
  String? errorMessage;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchPastAttackReports();
  }

  Future<void> fetchPastAttackReports() async {
    setState(() {
      isLoading = true; // Show loader when fetching reports
    });
    final url = 'https://rabitrack-backend-production.up.railway.app/getCasesByDoctorId/${widget.doctorId}';
    print('Fetching reports for Doctor ID: ${widget.doctorId} with JWT: ${widget.jwtToken}');
    try {
      final formattedToken = widget.jwtToken.trim();

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Cookie': 'jwttoken=${formattedToken}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        setState(() {
          attackReports = decodedResponse;
          filteredReports = decodedResponse;

          errorMessage = null;
          isLoading = false;
          isFilterEnabled = true; // Enable filter only if the response is successful
        });
      } else if (response.statusCode == 404) {
        setState(() {
          attackReports = [];
          filteredReports = [];
          errorMessage = 'No past reports found';
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = "User doesn't have permission";
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load reports';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load reports';
        isLoading = false;
      });
    }
    finally {
      setState(() {
        isLoading = false; // Hide loader after fetching
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _filterReportsByDate(selectedDate!);
      });
    }
  }

  void _filterReportsByDate(DateTime date) {
    String formattedDate = "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";  // Format as dd-MM-yyyy
    setState(() {
      filteredReports = attackReports.where((report) => report['attack_date'] == formattedDate).toList();
    });
  }

  void _resetFilter() {
    setState(() {
      filteredReports = attackReports; // Reset to all reports
      selectedDate = null; // Clear selected date
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Token received in PastAttackReportsPage: ${widget.jwtToken}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
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
        if (isFilterEnabled)
    // Display the filter button only if the filter is enabled
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(
              selectedDate == null
                  ? 'Filter by Date'
                  : 'Selected Date: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
            ),
          ),
          if (selectedDate != null) // Show Reset button only if a date is selected
            SizedBox(width: 10), // Spacing between buttons
          if (selectedDate != null)
            ElevatedButton(
              onPressed: _resetFilter,
              child: Text(
                'Reset',
                style: TextStyle(fontSize: 12), // Smaller font size
              ),

            ),
        ],
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
                  if (errorMessage == 'Failed to load reports')
    ElevatedButton(
    onPressed: () async {
    setState(() {
    isLoading = true; // Show loading indicator
    });

    await Future.delayed(Duration(seconds: 1)); // Ensure loading indicator shows for at least 1 second

    // Call the fetch function
    await fetchPastAttackReports();

    // Stop the loading indicator after fetching
    setState(() {
    isLoading = false;
    });
    },
    child: isLoading
    ? SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
    )
        : Text('Retry'),
    ),

    ],
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: filteredReports.length,
              itemBuilder: (context, index) {
                final report = filteredReports[index];
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaseDetailsPage(
                          caseId: report['case_id'],
                          jwtToken: widget.jwtToken,
                        ),
                      ),
                    );

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
                          offset: Offset(0, 3),
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
                        SizedBox(height: 4),
                        Text( // New field for owner name
                          'Owner: ${report['victim_owner']}', // Adjust the key if necessary
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey.shade700,
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
