import 'dart:convert'; // For decoding JSON response
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package for API calls
import 'package:doctor_app/profile_page.dart';
import 'package:doctor_app/home.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  // Store the data from the API
  Map<String, dynamic> districtCases = {};

  // Variable to hold error messages
  String? errorMessage; // Changed to nullable to indicate no error initially

  // Function to fetch case count data from the API
  Future<void> fetchCaseData() async {
    try {
      final response = await http.get(Uri.parse('https://rabitrack-backend-production.up.railway.app/getCaseCount'));

      print('Response status: ${response.statusCode}'); // Log status code
      print('Response body: ${response.body}'); // Log response body

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          setState(() {
            districtCases = {
              for (var item in data) item['district']: item['count'] // Change 'cases' to 'count'
            };
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e'); // Log error
      setState(() {
        errorMessage = 'Failed to load data'; // Set the error message
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCaseData(); // Fetch data when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for the main content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Centered heading
            Text(
              'ANALYSIS',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), // Heading style
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Space between heading and logo

            // Logo
            Image.asset(
              'assets/google_map.png',
              width: 400, // Replace with your logo path
              height: 200, // Adjust the size of the logo
              fit: BoxFit.cover, // Cover the space while maintaining aspect ratio
            ),
            SizedBox(height: 20), // Space between logo and districts

            // Error message display
            if (errorMessage != null) // Check if there's an error message
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16), // Error message style
                ),
              ),

            // Districts List
            districtCases.isEmpty
                ? CircularProgressIndicator() // Show a loader while data is being fetched
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
        currentIndex: 1, // Set the current index to the Statistics page
        selectedItemColor: Colors.blue,
        onTap: (index) {
          if (index == 0) {
            // Navigate to HomePage
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          } else if (index == 2) {
            // Navigate to ProfilePage
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          }
        },
      ),
    );
  }

  // Method to build each district card
  Widget buildDistrictCard(String districtName, String cases) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10), // Space between cards
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding inside the card
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between elements
          children: [
            Text(
              districtName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Circle with case data
            Column(
              children: [
                CircleAvatar(
                  radius: 30, // Circle size
                  backgroundColor: Colors.blue, // Circle background color
                  child: Text(
                    cases,
                    style: TextStyle(color: Colors.white, fontSize: 16), // Case count style
                  ),
                ),
                SizedBox(height: 5), // Space between circle and label
                Text(
                  'No. of cases',
                  style: TextStyle(color: Colors.red), // Label style
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
