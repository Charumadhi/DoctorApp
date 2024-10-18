import 'package:flutter/material.dart';
import 'package:RABI_TRACK/statistics.dart'; // Import your StatisticsPage
import 'package:RABI_TRACK/home.dart'; // Import your HomePage
import 'package:RABI_TRACK/profile_page.dart'; // Import your ProfilePage
import 'theme_provider.dart'; // Import your theme provider
import 'package:http/http.dart' as http;
import 'dart:convert'; // Add this line

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
          // Centered content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 60), // Add some space from the top

                    // Centered Logo Image
                    Image.asset(
                      'assets/Rabitrackrivertr.png', // Replace with your logo image path
                      width: 50, // Adjust logo size as needed
                      height: 70,
                    ),

                    const SizedBox(height: 20), // Space between logo and text

                    // Welcome Text
                    const Text(
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
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final TextEditingController idController = TextEditingController();


    return Column(
      children: [
        // Doctor ID Field
        TextField(
          controller: idController,
          decoration: InputDecoration(
            labelText: 'Doctor ID',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            prefixIcon: const Icon(Icons.medical_services, color: Colors.black),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.7), // Add a consistent border color
              ),
            ),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 20),

        // Password Field


        // "Paw Button" (Small, round button with only paw icon)
        Center(
          child: SizedBox(
            width: 60, // Small circular button
            height: 60,
            child: ElevatedButton(
              onPressed: () async {
                // Extract doctor ID and password
                final doctorId = idController.text.trim();

                print("Id is $doctorId");

                // Log the request URL for debugging
                final url = 'https://rabitrack-backend-production.up.railway.app/login';

                try {
                  // Create JSON body
                  final body = jsonEncode({
                    'doctorId': doctorId, // Include doctorId in the JSON body
                  });

                  final response = await http.post(
                    Uri.parse(url),
                    headers: {
                      'Content-Type': 'application/json', // Required for POST
                      'Accept': 'application/json',
                    },
                    body: body, // Send the JSON body
                  );


                  // Log the response status and body for debugging
                  print("Response status: ${response.statusCode}");
                  print("Response body: ${response.body}");

                  print("Id is $doctorId");

                  // Check if the response is successful
                  if (response.statusCode == 200) {
                    try {
                      final data = json.decode(response.body);
                      print("The data is: $data");

                      // Logging individual details for verification
                      print("Doctor ID: ${data['doctor_id']}");
                      print("Doctor Name: ${data['doctor_name']}");
                      print("Working In: ${data['working_in']}");
                      print("District: ${data['district']}");
                      print("Area: ${data['area']}");

                      if (data['isAuth'] == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                            settings: RouteSettings(
                              arguments: {
                                'doctorName': data['doctor_name'], // Assuming these keys are in the response
                                'doctorId': data['doctor_id'],      // Ensure these keys exist in the response
                                'area': data['area'],
                                'district': data['district'],
                              },
                            ),
                          ),
                        );
                      } else {
                        _showErrorDialog(context, "Invalid credentials");
                      }
                    } catch (jsonError) {
                      // Handle JSON decoding error
                      _showErrorDialog(context, "Unexpected server response");
                      print("JSON parsing error: $jsonError");
                    }
                  } else {
                    print("Error: ${response.reasonPhrase}"); // Log reason phrase
                  }
                } catch (error) {
                  _showErrorDialog(context, "An error occurred");
                  print("Error logging in: $error");
                }
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

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {

    final TextEditingController nameController = TextEditingController();
    final TextEditingController regNoController = TextEditingController();
    final TextEditingController areaController = TextEditingController();
    String? workType;
    String? workDistrict;

    return Column(
      children: [
        // Name Field
        TextField(
          controller: nameController,
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
          controller: regNoController,
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
          onChanged: (String? value) {
            workType = value;
          },
        ),
        const SizedBox(height: 30),
        // Address of Workplace Field
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Working district',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          items: <String>['Puducherry', 'Karaikal', 'Mahe', 'Yenam']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.black)),
            );
          }).toList(),
          onChanged: (String? value) {
            workDistrict = value;
          },
        ),
        const SizedBox(height: 20),

        // Additional Fields based on Work Type
        // (These fields can be shown conditionally based on the dropdown selection)
        TextField(
          controller: areaController,
          decoration: InputDecoration(
            labelText: 'Area of working',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        // Register Button
        ElevatedButton(
          onPressed: () async {
            // Gather data from the form
            final String name = nameController.text.trim();
            final String regNo = regNoController.text.trim();
            final String area = areaController.text.trim();

            if (name.isEmpty || regNo.isEmpty || area.isEmpty || workType == null || workDistrict == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill in all fields.')),
              );
              return; // Exit the function early
            }

            // Define the API endpoint
            final url = 'https://rabitrack-backend-production.up.railway.app/signup';

            // Send a POST request
            try {
              final headers = {'Content-Type': 'application/json'};
              final data = {
                'doctorId': regNo,
                'doctorName': name,
                'workingIn': workType,
                'district': workDistrict,
                'area': area,
              };

              print('Sending request to $url with data: $data');

              final response = await http.post(
                Uri.parse(url),
                headers: headers,
                body: json.encode(data),
              );


              print('Response status: ${response.statusCode}');
              print('Response body: ${response.body}');


              if (response.statusCode == 200) {
                // Define arguments to pass to the home page
                final Map<String, String> arguments = {
                  'doctorName': name,
                  'doctorId': regNo,
                };

                // Navigate to the home page and pass arguments
                Navigator.pushNamed(
                  context,
                  '/home',
                  arguments: arguments,
                );
              }else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registration failed.')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Network error occurred.')),
              );
            }
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
        child: const Text('Registration Page Goes Here'),
      ),
    );
  }
}
