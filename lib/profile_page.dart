import 'package:flutter/material.dart';
import 'package:RABI_TRACK/credits.dart'; // Replace with correct path if needed
import 'package:RABI_TRACK/home.dart'; // Ensure HomePage is imported
import 'package:RABI_TRACK/statistics.dart'; // Update with the correct path if necessary
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String jwtToken;

  ProfilePage({required this.jwtToken});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _jwtToken;

  @override
  void initState() {
    super.initState();
    _jwtToken = widget.jwtToken; // Initialize the jwtToken
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> doctor = (arguments as Map<String, dynamic>?)?['doctor'] ?? {};

    final String doctorName = doctor['doctorName'] ?? 'Unknown';
    final String doctorId = doctor['doctorId'] ?? 'Unknown';
    final String area = doctor['area'] ?? 'Unknown';
    final String district = doctor['district'] ?? 'Unknown';
    print('Doctor ID: $doctorId');
    print('Doctor Name: $doctorName');
    print('Area: $area');
    print('District: $district');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
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
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/doctor.jpg'),
              ),
              SizedBox(height: 20),
              Text(
                'Dr. $doctorName',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Doctor ID: $doctorId', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Area: $area', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('District: $district', style: TextStyle(fontSize: 16)),
              SizedBox(height: 30),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.info, size: 30),
                  title: Text('Credits', style: TextStyle(fontSize: 20)),
                  onTap: () async {
                    // Navigate to CreditsPage and wait for the returned jwtToken
                    final returnedJwtToken = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreditsPage(jwtToken: _jwtToken)),
                    );

                    if (returnedJwtToken != null) {
                      setState(() {
                        _jwtToken = returnedJwtToken; // Update jwtToken when returned
                      });
                    }
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.logout, size: 30),
                  title: Text('Log Out', style: TextStyle(fontSize: 20)),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('jwtToken');
                    final token = prefs.getString('jwtToken');
                    print('Token after removal: $token');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logged out')),
                    );
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistics'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
                settings: RouteSettings(arguments: {
                  'doctorId': doctorId,
                  'doctorName': doctorName,
                  'area': area,
                  'district': district,
                  'jwtToken': widget.jwtToken,
                }),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StatisticsPage(jwtToken: _jwtToken),
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
}
