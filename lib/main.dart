import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:RABI_TRACK/home.dart'; // Import your HomePage
import 'package:RABI_TRACK/profile_page.dart'; // Import your ProfilePage
import 'package:RABI_TRACK/statistics.dart'; // Import your StatisticsPage
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


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
        colorScheme: ColorScheme.light(primary: Colors.blue),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => HomePage(),
        '/statistics': (context) {
          final String jwtToken = ModalRoute.of(context)!.settings.arguments as String;
          return StatisticsPage(jwtToken: jwtToken);
        },
        '/profile': (context) {
          final String jwtToken = ModalRoute.of(context)!.settings.arguments as String;
          return ProfilePage(jwtToken: jwtToken);
        },
        '/register': (context) => const RegistrationPage(),
      },
    );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwttoken');
    final doctorId = prefs.getString('doctorId');
    final doctorName = prefs.getString('doctorName');
    final area = prefs.getString('area');
    final district = prefs.getString('district');

    if (token != null && token.isNotEmpty) {
      // Token and data exist, navigate to Home Page with required arguments
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
          settings: RouteSettings(
            arguments: {
              'doctorName': doctorName,
              'doctorId': doctorId,
              'area': area,
              'district': district,
              'jwtToken': token, // Pass the trimmed token
            },
          ),
        ),
      );
    } else {
      // No token, navigate to Login Page
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  bool isLogin = true; // Toggle between login and registration
  bool isLoading = false; // Add loading state
  late AnimationController _controller;
  late Animation<double> _animation;
  final TextEditingController idController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController regNoController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();




  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        // Format the date as YYYY-MM-DD
        dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reset animation when completed
        _controller.reverse();
      }
    });
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                    const SizedBox(height: 60),

                    // Centered Logo Image
                    Image.asset(
                      'assets/Rabitrackrivertr.png', // Replace with your logo image path
                      width: 50,
                      height: 70,
                    ),

                    const SizedBox(height: 20),

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
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: dobController,
          decoration: InputDecoration(
            labelText: 'Date of Birth (YYYY-MM-DD)',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.black),
              onPressed: () => _selectDate(context), // Open date picker
            ),
          ),
          style: const TextStyle(color: Colors.black),
          readOnly: true, // Prevent manual input
        ),
        const SizedBox(height: 20),
        // "Paw Button"
        Center(
          child: ScaleTransition(
            scale: _animation,
            child: SizedBox(
              width: 60,
              height: 60,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                  setState(() {
                    isLoading = true; // Set loading to true
                    _controller.forward(); // Start the animation
                  });

                  final doctorId = idController.text.trim();
                  final dob = dobController.text.trim();
                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('jwttoken');

                  if (doctorId.isEmpty || dob.isEmpty) {
                    setState(() {
                      isLoading = false; // Reset loading state
                    });
                    _showErrorDialog(context, "Please enter all the fields");
                    return;
                  }

                  final doctorIdPattern = RegExp(r'^PVC\d{4}$');
                  if (!doctorIdPattern.hasMatch(doctorId)) {
                    setState(() {
                      isLoading = false;
                    });
                    _showErrorDialog(context, "Invalid Doctor ID format. Please use the format PVCXXXX.");
                    return;
                  }

                  final url = 'https://rabitrack-backend-production.up.railway.app/login';

                  try {
                    final body = jsonEncode({
                      'doctorId': doctorId,
                      'DOB': dob,
                    });

                    final response = await http.post(
                      Uri.parse(url),
                      headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization': 'Bearer $token', // Include token if available
                      },
                      body: body,
                    );

                    if (response.statusCode == 200) {
                      final data = json.decode(response.body);
                      if (data['isAuth'] == true) {
                        // Extract and trim the JWT token
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String token = response.headers['set-cookie']?.split('=')[1]?.split(';')[0].trim() ?? '';
                        await prefs.setString('jwttoken', token);
                        await prefs.setString('doctorId', data['doctor_id']);
                        await prefs.setString('doctorName', data['doctor_name']);
                        await prefs.setString('area', data['area']);
                        await prefs.setString('district', data['district']);// Store trimmed token

                        // Navigate to HomePage with the JWT token
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                            settings: RouteSettings(
                              arguments: {
                                'doctorName': data['doctor_name'],
                                'doctorId': data['doctor_id'],
                                'area': data['area'],
                                'district': data['district'],
                                'jwtToken': token, // Pass the trimmed token
                              },
                            ),
                          ),
                        );
                      } else if (data['error'] == 'Doctor not found') {
                        _showErrorDialog(context, "No such doctor exists");
                      } else {
                        _showErrorDialog(context, "Invalid credentials");
                      }
                    } else if (response.statusCode == 401) {
                      _showErrorDialog(context, "Invalid Credentials. Please try again.");
                    } else {
                      _showErrorDialog(context, "An error occurred. Please try again.");
                    }
                  } catch (error) {
                    _showErrorDialog(context, "An error occurred");
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },




                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15),
                  elevation: 5,
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white) // Show loader
                    : const Icon(Icons.pets, color: Colors.white), // Only the paw icon
              ),
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
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {

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
        TextFormField(
          controller: dobController,
          decoration: InputDecoration(
            labelText: 'Date of Birth (YYYY-MM-DD)',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.black),
              onPressed: () => _selectDate(context), // Open date picker
            ),
          ),
          style: const TextStyle(color: Colors.black),
          readOnly: true, // Prevent manual input
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: mobileController,
          decoration: InputDecoration(
            labelText: 'Mobile Number',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your mobile number';
            } else if (value.length != 10) {
              return 'Mobile number must be exactly 10 digits';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        // Work Type Dropdown
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

        const SizedBox(height: 20),

        // Work District Dropdown
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Work District',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          items: <String>['Puducherry', 'Karaikal', 'Mahe', 'Yanam'] // Add more districts as needed
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
            print("Register button pressed");

            // Gather data from the form
            final String name = nameController.text.trim();
            final String regNo = regNoController.text.trim();
            final String area = areaController.text.trim();
            final doctorId = regNoController.text.trim();
            final String dob = dobController.text.trim();
            final String mobile = mobileController.text.trim();

            // Check for empty fields
            if (name.isEmpty || regNo.isEmpty || dob.isEmpty|| area.isEmpty || workType == null || workDistrict == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill in all fields.')),
              );
              return;
            }

            final doctorIdPattern = RegExp(r'^PVC\d{4}$');

            print("Doctor ID entered: '$doctorId'");
            // Validate the doctorId format
            if (!doctorIdPattern.hasMatch(doctorId)) {
              _showErrorDialog(context, "Invalid Doctor ID format. Please use the format PVCXXXX.");
              return;
            }

            // Define the API endpoint
            final url = 'https://rabitrack-backend-production.up.railway.app/signup';

            // Send a POST request
            try {
              final headers = {'Content-Type': 'application/json'};
              final data = {
                'doctorId': regNo,
                'doctorName': name,
                'DOB': dob,
                'workingIn': workType,
                'district': workDistrict,
                'area': area,
                'mobile': mobile,
              };

              print('Sending request to $url with data: $data');

              final response = await http.post(
                Uri.parse(url),
                headers: headers,
                body: json.encode(data),
              );

              print('Response status: ${response.statusCode}');
              print('Response body: ${response.body}');

              final responseBody = json.decode(response.body);

              if (response.statusCode == 200 && responseBody['Success'] == true) {
                // Registration successful
                final Map<String, String> arguments = {
                  'doctorName': name,
                  'doctorId': regNo,
                };

                Navigator.pushNamed(
                  context,
                  '/login',
                  arguments: arguments,
                );
              } else if (response.statusCode == 409 && responseBody['error'] == "doctor with the given ID is already registered") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Doctor with the given ID is already registered.')),
                );
              } else {
                print("Registration failed: ${responseBody['error']}");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registration failed. Please try again.')),
                );
              }
            } catch (e) {
              print("Error occurred: $e");
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