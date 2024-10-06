// import 'package:flutter/material.dart';
// import 'attack_form.dart'; // Import the AttackForm screen
//  // Import your StatisticsPage if not already done
// import 'package:doctor_app/statistics.dart';
// import 'attacker_details.dart';
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Home Page',
//           style: TextStyle(color: Colors.white), // White title color
//         ),
//         backgroundColor: Colors.blue[1500], // Dark Blue for AppBar
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           color: Colors.white, // White background
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Welcome Back text
//               Text(
//                 'Welcome Back',
//                 style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.blue[900]), // Blue text
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 10),
//
//               // Name text
//               Text(
//                 'Dr. Jenniffer',
//                 style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue[900]), // Blue name text
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20),
//
//               // Round avatar image
//               CircleAvatar(
//                 radius: 50,
//                 backgroundImage:
//                 AssetImage('assets/your_avatar_image.png'), // Replace with your avatar image path
//               ),
//               SizedBox(height: 30),
//
//               // Button for View Past Attack Reports
//               buildActionButton(
//                 context,
//                 'View Past Attack Reports',
//                 Icons.visibility,
//                 Colors.grey[300] ?? Colors.grey, // Default to grey if null
//                 Colors.blue[900] ?? Colors.blue, // Default to blue if null
//               ),
//               SizedBox(height: 25),
//
//               // Button for Create New Attack Report
//               buildActionButton(
//                 context,
//                 'Create New Attack Report',
//                 Icons.create,
//                 Colors.grey[300] ?? Colors.grey, // Default to grey if null
//                 Colors.blue[900] ?? Colors.blue, // Default to blue if null
//                 navigateTo: AttackFormPage(), // Pass the AttackForm screen to navigate to
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bar_chart),
//             label: 'Statistics',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: 0, // Set the current tab to "Home"
//         selectedItemColor: Colors.blue,
//         onTap: (index) {
//           if (index == 0) {
//             // Already on HomePage, do nothing or show a snackbar
//           } else if (index == 1) {
//             // Navigate to StatisticsPage
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => StatisticsPage()),
//             );
//           } else if (index == 2) {
//             // Navigate to ProfilePage
//             Navigator.pushNamed(context, '/profile'); // Adjust this based on your routing setup
//           }
//         },
//       ),
//     );
//   }
//
//   Widget buildActionButton(BuildContext context, String text, IconData icon, Color bgColor, Color textColor, {Widget? navigateTo}) {
//     return GestureDetector(
//       onTap: () {
//         if (navigateTo != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => navigateTo), // Navigate to the specified screen
//           );
//         }
//       },
//       child: Container(
//         width: double.infinity, // Full width button
//         height: 150, // Set a fixed height for the button to make it bigger
//         padding: const EdgeInsets.all(20.0), // Padding for button
//         decoration: BoxDecoration(
//           color: bgColor, // Background color for the button
//           borderRadius: BorderRadius.circular(8), // Rounded corners
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5), // Shadow effect
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3), // Shadow position
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Icon at the top left corner
//             Icon(
//               icon,
//               color: textColor, // Icon color
//               size: 30, // Icon size
//             ),
//             SizedBox(width: 10), // Space between icon and text
//             Expanded(
//               child: Text(
//                 text,
//                 style: TextStyle(
//                     color: textColor, fontSize: 30, fontWeight: FontWeight.w500), // Text style
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'attack_form.dart'; // Import the AttackForm screen
import 'package:doctor_app/statistics.dart';
import 'attacker_details.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind the AppBar for better integration with the background image
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.black), // White title color
        ),
        backgroundColor: Colors.transparent, // Transparent AppBar for seamless integration
        elevation: 0, // Remove shadow under AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://img.freepik.com/free-photo/decorative-background-with-smoke_23-2147611841.jpg?t=st=1728209013~exp=1728212613~hmac=46bdd6f6b5b50ec9aabecdc0befb6598e421c9e426c640612f9adef4aaad9656&w=360'), // Replace with your network image URL
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.blue.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0), // Increased padding for a cleaner look
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: kToolbarHeight + 20), // Adjust for AppBar height

              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // White text for better visibility
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
                'Dr. Jenniffer',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // White name text
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
              SizedBox(height: 20),

              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/logo.png'), // Replace with your avatar image path
              ),
              SizedBox(height: 40),

              buildActionButton(
                context,
                'View Past Attack Reports',
                Icons.visibility,
                Colors.indigo.withOpacity(0.6),
                Colors.white,
              ),
              SizedBox(height: 25),

              buildActionButton(
                context,
                'Create New Attack Report',
                Icons.create,
                Colors.indigo.shade700.withOpacity(0.6),
                Colors.white,
                navigateTo: AttackFormPage(), // Pass the AttackForm screen to navigate to
              ),
            ],
          ),
        ),
      ),
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
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          if (index == 0) {
            // Already on HomePage, do nothing
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StatisticsPage()),
            );
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }

  Widget buildActionButton(BuildContext context, String text, IconData icon, Color bgColor, Color textColor, {Widget? navigateTo}) {
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
        height: 160,
        padding: const EdgeInsets.all(24.0),
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
              size: 40,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 26,
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
