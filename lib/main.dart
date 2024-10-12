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
        '/statistics': (context) => StatisticsPage(), // Define the route for StatisticsPage
        '/home': (context) => HomePage(), // Define the route for HomePage
        '/profile': (context) => ProfilePage(), // Define the route for ProfilePage
        '/register': (context) => const RegistrationPage(), // Define the route for RegistrationPage
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true; // Toggle between login and registration

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/doctorbg.png'), // Replace with your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Transparent Layer over the background for better text visibility
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 60), // Add some space from the top

                  // Logo Image
                  Center(
                    child: Image.asset(
                      'assets/Rabitrackrivertr.png', // Replace with your logo image path
                      width: 150,
                      height: 150,
                    ),
                  ),

                  const SizedBox(height: 30), // Space between logo and text

                  // Welcome Text
                  const Center(
                    child: Text(
                      'Welcome, Doctor!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black45,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Toggle Button
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin ? 'New User? Register Here' : 'Already a User? Login Here',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Conditional Form Rendering
                  isLogin ? _buildLoginForm(context) : _buildRegistrationForm(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      children: [
        // Doctor ID Field
        TextField(
          decoration: InputDecoration(
            labelText: 'Doctor ID',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            prefixIcon: const Icon(Icons.medical_services, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 20),

        // Password Field
        TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            prefixIcon: const Icon(Icons.lock, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          obscureText: true,
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 30),

        // "Paw Button" (Small, round button with only paw icon)
        Center(
          child: SizedBox(
            width: 60, // Small circular button
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                // Animate the transition to the HomePage with a "paw-like" effect
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = 0.0;
                      const end = 1.0;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var scaleAnimation = animation.drive(tween);

                      return ScaleTransition(
                        scale: scaleAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: const CircleBorder(), // Circular shape
                padding: const EdgeInsets.all(15), // Padding to make it circular
                elevation: 5,
              ),
              child: const Icon(Icons.pets, color: Colors.white), // Only the paw icon
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return Column(
      children: [
        // Name Field
        TextField(
          decoration: InputDecoration(
            labelText: 'Name',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 20),

        // Registration Number Field
        TextField(
          decoration: InputDecoration(
            labelText: 'Registration Number (e.g., PVC0058)',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 20),

        // Working In Field
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Working In',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          items: <String>['Government Sector', 'Private Sector']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.black)),
            );
          }).toList(),
          onChanged: (String? value) {},
        ),
        const SizedBox(height: 20),

        // Additional Fields based on Work Type
        // (These fields can be shown conditionally based on the dropdown selection)
        TextField(
          decoration: InputDecoration(
            labelText: 'Address of Workplace',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 30),

        // Register Button
        ElevatedButton(
          onPressed: () {
            // Handle registration logic here
            // For example, save user data and navigate to the HomePage
            Navigator.pushNamed(context, '/home');
          },
          child: const Text('Register'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Center(
        child: const Text('Registration Form Goes Here'), // Placeholder
      ),
    );
  }
}