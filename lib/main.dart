import 'package:flutter/material.dart';

void main() {
  runApp(const RabitrackRiverApp());
}

class RabitrackRiverApp extends StatelessWidget {
  const RabitrackRiverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rabitrack River',
      theme: ThemeData.light(),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Spacer(), // Push everything down

            // Title
            const Text(
              'Rabitrack River',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            // Username Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Password Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              obscureText: true, // Hide password input
            ),
            const SizedBox(height: 30),

            // Login Button
            SizedBox(
              width: 200, // Reduce button width
              child: ElevatedButton(
                onPressed: () {
                  // Add login functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(150, 60), // Fixed width
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 15,  // Set your desired font size here
                    )
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Register Button
            SizedBox(
              width: 200, // Reduce button width
              child: ElevatedButton(
                onPressed: () {
                  // Add register functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(150, 60),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                    'Register',
                  style: TextStyle(
                    fontSize: 15,  // Set your desired font size here
                  )
                ),
              ),
            ),
            const Spacer(), // Pushes everything above towards the top

            // Image and Text at the bottom
            Column(
              children: [
                Image.network(
                  'https://img.freepik.com/free-vector/veterinary-with-dog_1196-293.jpg?t=st=1727916940~exp=1727920540~hmac=a6e9d714781022620342ad3b63f0d32fa1e4495d53db3afe744981fdc43f158f&w=740',
                  width: 200,
                  height: 220,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Pawsitive Care, Every Time.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
