import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PastAttackReportsPage extends StatefulWidget {
  final String doctorId;

  const PastAttackReportsPage({Key? key, required this.doctorId}) : super(key: key);

  @override
  _PastAttackReportsPageState createState() => _PastAttackReportsPageState();
}

class _PastAttackReportsPageState extends State<PastAttackReportsPage> {
  List<dynamic> attackReports = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchPastAttackReports();
  }

  Future<void> fetchPastAttackReports() async {
    final url = 'https://rabitrack-backend-production.up.railway.app/getCasesByDoctorId:${widget.doctorId}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          attackReports = json.decode(response.body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Attack Reports'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? Center(child: Text('Failed to load reports'))
          : ListView.builder(
        itemCount: attackReports.length,
        itemBuilder: (context, index) {
          final report = attackReports[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('Report ID: ${report['reportId']}'),
              subtitle: Text('Date: ${report['date']}'),
            ),
          );
        },
      ),
    );
  }
}
