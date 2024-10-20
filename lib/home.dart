import 'package:RABI_TRACK/past_attack_reports.dart';
import 'package:RABI_TRACK/profile_page.dart'; // Import ProfilePage if necessary
import 'package:RABI_TRACK/statistics.dart';
import 'package:flutter/material.dart';

import 'attack_form.dart'; // Import the AttackForm screen

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // If arguments are not null, cast to Map<String, dynamic>
    final Map<String, dynamic> doctor = arguments ?? {};

    // Get the doctor name and ID from the arguments
    final String doctorName = doctor['doctorName'] ?? 'Unknown';
    final String doctorId = doctor['doctorId'] ?? 'Unknown';
    final String area = doctor['area'] ?? 'Unknown';
    final String district = doctor['district'] ?? 'Unknown';
    final String jwtToken = doctor['jwtToken']?? '';
    print('Doctor ID: $doctorId, Name: $doctorName, Area: $area, District: $district, JWT: $jwtToken');
    print('Sending Doctor Info to StatisticsPage: $doctor');
    print("Token got from main file: $jwtToken");
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        // Ensure the Container takes up the full screen
        width: double.infinity,
        height: double.infinity, // Use full height
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/bg1.avif'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.blue.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: kToolbarHeight + 20),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Dr. $doctorName ',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black54,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/doctor.jpg'),
                ),
                SizedBox(height: 40),
                buildActionButton(
                  context,
                  'View Past Attack Reports',
                  Icons.visibility,
                  Colors.indigo.withOpacity(1),
                  Colors.white,
                  navigateTo: PastAttackReportsPage(doctorId: doctorId,jwtToken: jwtToken), // Pass doctorId here
                  height: 100, // Set a smaller height for the button
                ),
                SizedBox(height: 25),
                buildActionButton(
                  context,
                  'Create New Attack Report',
                  Icons.create,
                  Colors.indigo.shade700.withOpacity(1),
                  Colors.white,
                  navigateTo: AttackFormPage(
                    doctorId: doctorId,
                    doctorName: doctorName,
                    area: area,
                    district: district,
                    jwtToken: jwtToken
                  ),
                  height: 100, // Set a smaller height for the button
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent, // Make the background transparent
        elevation: 0, // Remove shadow/elevation effect
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
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          if (index == 0) {
            // Already on HomePage, do nothing
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StatisticsPage(jwtToken: jwtToken),
                settings: RouteSettings(arguments: {
                  'doctor': doctor,


                }),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(jwtToken: jwtToken),
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

  Widget buildActionButton(BuildContext context, String text, IconData icon, Color bgColor, Color textColor, {Widget? navigateTo, double height = 160}) {
    return GestureDetector(
      onTap: () {
        if (navigateTo != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => navigateTo),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: height, // Set the height for the button here
        padding: const EdgeInsets.all(12.0), // Adjust padding if needed
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 8,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: textColor,
              size: 30, // Adjust icon size if needed
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20, // Adjust font size if needed
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
