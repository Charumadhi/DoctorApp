import 'dart:convert'; // For decoding JSON response

import 'package:RABI_TRACK/home.dart';
import 'package:RABI_TRACK/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package for API calls

class StatisticsPage extends StatefulWidget {
  final String jwtToken;

  StatisticsPage({required this.jwtToken}) {
    // Print the JWT token when the StatisticsPage is created
    print('JWT Token: $jwtToken'); // Log the token
  }

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  Map<String, dynamic> districtCases = {};
  String? errorMessage;

  Future<void> fetchCaseData() async {
    final url = "https://rabitrack-backend-production.up.railway.app/getCaseCount";
    try {
      final formattedToken = widget.jwtToken.trim();

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Cookie': 'jwttoken=${formattedToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          setState(() {
            districtCases = {
              for (var item in data) item['district']: item['count']
            };
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCaseData();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> doctor = (arguments as Map<String, dynamic>?)?['doctor'] ?? {};

    final String doctorName = doctor['doctorName'] ?? 'Unknown';
    final String doctorId = doctor['doctorId'] ?? 'Unknown';
    final String area = doctor['area'] ?? 'Unknown';
    final String district = doctor['district'] ?? 'Unknown';
    print('Doctor ID: $doctorId');
    print('Doctor Name: $doctorName');
    print('Area: $area');
    print('District: $district');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'ANALYSIS',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/google_map.png',
              width: 400,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            districtCases.isEmpty
                ? CircularProgressIndicator()
                : Expanded(
              child: ListView(
                children: districtCases.entries.map((entry) {
                  return buildDistrictCard(entry.key, entry.value.toString());
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
                settings: RouteSettings(arguments: {
                  'doctorId': doctorId,
                  'doctorName': doctorName,
                  'area': area,
                  'district': district,
                  'jwtToken': widget.jwtToken,
                }),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(jwtToken: widget.jwtToken),
                settings: RouteSettings(arguments: {
                  'doctor': doctor,


                }),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildDistrictCard(String districtName, String cases) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              districtName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: Text(
                    cases,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'No. of cases',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
