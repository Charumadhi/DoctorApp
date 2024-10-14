import 'package:flutter/material.dart';
import 'package:doctor_app/credits.dart'; // Replace with correct path if needed
import 'package:doctor_app/statistics.dart'; // Update with the correct path if necessary
import 'package:doctor_app/home.dart'; // Ensure HomePage is imported

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Retrieve the doctor information passed as arguments
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> doctorInfo = arguments as Map<String, dynamic>;

    // Get the doctor name and ID from the arguments
    final String doctorName = doctorInfo['doctorName'] ?? 'Unknown';
    final String doctorId = doctorInfo['doctorId'] ?? 'Unknown';
    final String area = doctorInfo['area'] ?? 'Unknown';
    final String district = doctorInfo['district'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/doctor.jpg'), // Replace with your avatar image
              ),
              SizedBox(height: 20),

              // Display the doctor’s name dynamically
              Text(
                'Dr. $doctorName',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Doctor ID: $doctorId',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10),
              Text(
                'Area: $area',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10),
              Text(
                'District: $district',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 30), // Spacing from top

              // Credits Option
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.info, size: 30),
                  title: Text('Credits', style: TextStyle(fontSize: 20)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreditsPage()),
                    );
                  },
                ),
              ),

              // Logout Option
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
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
              ),
            ],
          ),
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
            // Navigate to HomePage and pass doctorInfo
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
                settings: RouteSettings(arguments: doctorInfo),
              ),
            );
          } else if (index == 1) {
            // Navigate to StatisticsPage and pass doctorInfo
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StatisticsPage(),
                settings: RouteSettings(arguments: doctorInfo),
              ),
            );
          }
          // No action for Profile since we are already on this page
        },
      ),
    );
  }
}
