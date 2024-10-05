import 'package:flutter/material.dart';
import 'package:doctor_app/statistics.dart'; // Import your StatisticsPage
import 'package:doctor_app/home.dart'; // Import your HomePage
import 'package:doctor_app/profile_page.dart'; // Import your ProfilePage
import 'theme_provider.dart'; // Import your theme provider

void main() {
  runApp(const RabitrackRiverApp());
}

class RabitrackRiverApp extends StatelessWidget {
  const RabitrackRiverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rabitrack River',
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.light(primary: Colors.blue), // Set the primary color
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black), // Default text color
        ),
      ),
      initialRoute: '/login', // Set the initial route
      routes: {
        '/login': (context) => const LoginPage(), // Define the route for LoginPage
        '/statistics': (context) =>  StatisticsPage(), // Define the route for StatisticsPage
        '/home': (context) =>  HomePage(), // Define the route for HomePage
        '/profile': (context) =>  ProfilePage(), // Define the route for ProfilePage
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Top Image
              Image.asset(
                'assets/rabitrack.jpeg', // Replace with your logo path
                width: 120,
                height: 290,
              ),

              // Space between image and text
              Container(
                padding: const EdgeInsets.all(10), // Padding around the text
                color: Colors.transparent, // Background color
                child: const Text(
                  'RABITRACK RIVER', // Replace with your desired text
                  style: TextStyle(
                    fontFamily: 'Averia Gruesa Libre', // Ensure the font is added to pubspec.yaml
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800,
                    height: 22 / 38, // Line height based on font size
                    color: Color(0xFF056839), // Text color
                  ),
                  textAlign: TextAlign.left, // Text alignment
                ),
              ),
              const SizedBox(height: 30), // Optional space at the bottom

              // Greeting Text
              const Text(
                'Hello Doctor👨‍⚕️🩺',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Doctor ID Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Doctor ID',
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.grey[300],
                  prefixIcon: const Icon(Icons.medical_services, color: Colors.black), // Icon for Doctor ID
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),

              // Password Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.grey[300],
                  prefixIcon: const Icon(Icons.lock, color: Colors.black), // Icon for Password
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                obscureText: true, // Hide password input
              ),
              const SizedBox(height: 30),

              // Let's Analyze Button
              SizedBox(
                width: 200, // Reduce button width
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to HomePage when button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(150, 60), // Fixed width
                    foregroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.pets), // Paw symbol
                      SizedBox(width: 10), // Space between icon and text
                      Text(
                        "Let's Analyze",
                        style: TextStyle(
                          fontSize: 15, // Set your desired font size here
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Existing Image and Text
              Column(
                children: [
                  Image.asset(
                    'assets/doodle.png', // Replace with your logo path
                    width: 120,
                    height: 120,
                  ),

                  const Text(
                    'Pawsitive Care, Every Time!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30), // Optional space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
