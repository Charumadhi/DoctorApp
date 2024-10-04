import 'package:flutter/material.dart';
import 'package:doctor_app/statistics.dart';
class CreditsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credits'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // An Initiative by section
            Text(
              'An Initiative by',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // Heading style
            ),
            SizedBox(height: 10), // Space between heading and content
            Row(
              children: [
                Image.asset(
                  'assets/River_Logo.png', // Replace with your logo path
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 10), // Space between image and text
                Expanded(
                  child: Text(
                    'Department of Veterinary Public Health and Epidemiology, RIVER',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Space between sections

            // Under Guidance of section
            Text(
              'Under Guidance of',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // Heading style
            ),
            SizedBox(height: 10), // Space between heading and content
            Row(
              children: [
                Image.asset(
                  'assets/aic_logo.png', // Replace with your logo path
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mr. Vishnu Varadhan',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'CEO, ATAL-PECF',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Space between sections

            // Development Team section
            Text(
              'Development Team',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // Heading style
            ),
            SizedBox(height: 10), // Space between heading and content
            Row(
              children: [
                Image.asset(
                  'assets/ptu-logo.png', // Replace with your logo path
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shefaoudeen Z',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Design Club of PTU',
                        style: TextStyle(fontSize: 14, color: Colors.grey), // Light color
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Image.asset(
                  'assets/logo.png', // Replace with your logo path
                  width: 50,
                  height: 50,
                ),
              ],
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 2, // Set the current tab to "Profile"
        selectedItemColor: Colors.blue,
    onTap: (index) {
    if (index == 0) {
    // Navigate to HomePage
    Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
    // Navigate to HistoryPage
    Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsPage()));

    }
    },
      ),
    );
  }
}
