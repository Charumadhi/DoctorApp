import 'package:flutter/material.dart';
import 'package:doctor_app/credits.dart'; // Replace with correct path if needed
import 'package:doctor_app/statistics.dart'; // Update with the correct path if necessary
import 'main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDarkTheme = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkTheme = value;
    });

    // Use the theme toggle logic here (global app theme change)
    if (_isDarkTheme) {
      // Switch to dark theme logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Switched to Dark Theme')),
      );
    } else {
      // Switch to light theme logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Switched to Light Theme')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Center Title
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Hello!! Dr. Jenniffer',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 50), // Spacing from top

            // Theme Option
            ListTile(
              leading: Icon(Icons.brightness_6, size: 30),
              title: Text('Theme', style: TextStyle(fontSize: 20)),
              trailing: Switch(
                value: _isDarkTheme,
                onChanged: _toggleTheme,
                activeColor: Colors.blue,
                inactiveThumbColor: Colors.grey,
              ),
            ),
            SizedBox(height: 20), // Spacing between items

            // Credits Option
            ListTile(
              leading: Icon(Icons.info, size: 30),
              title: Text('Credits', style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreditsPage()),
                );
              },
            ),
            SizedBox(height: 20), // Spacing between items

            // Logout Option
            ListTile(
              leading: Icon(Icons.logout, size: 30),
              title: Text('Log Out', style: TextStyle(fontSize: 20)),
              onTap: () {
                // Log out logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out')),
                );

                // Navigate back to the login page
                Navigator.pushReplacementNamed(context, '/login'); // Ensure '/login' route is defined in your app
              },
            ),
          ],
        ),
      ),
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
          // No action for Profile since we are already on this page
        },
      ),
    );
  }
}
