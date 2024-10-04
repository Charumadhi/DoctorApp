import 'package:flutter/material.dart';
import 'package:doctor_app/profile_page.dart';
import 'package:doctor_app/home.dart';
class StatisticsPage extends StatelessWidget {
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
              'assets/google_map.png', // Replace with your logo path
              height: 200, // Adjust the size of the logo
              fit: BoxFit.cover, // Cover the space while maintaining aspect ratio
            ),
            SizedBox(height: 20), // Space between logo and districts

            // Districts List
            Expanded(
              child: ListView(
                children: [
                  buildDistrictCard('PUDUCHERRY', '20'), // Example data
                  buildDistrictCard('KARAIKAL', '15'),
                  buildDistrictCard('MAHE', '5'),
                  buildDistrictCard('YANAM', '10'),
                ],
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
          }


          else if (index == 2) {
            // Navigate to HistoryPage
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
            // Circle with dummy data
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
