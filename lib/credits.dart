import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Credits',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo[600],  // Elegant deep blue
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFd1c4e9),  // Soft lavender
              Color(0xFFffffff),  // White
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('An Initiative by'),
              _buildInfoCard(
                'assets/River_Logo.png',
                'Department of Veterinary Public Health and Epidemiology, RIVER',
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('Under Guidance of'),
              _buildInfoCardWithSubtitle(
                'assets/aic_logo.png',
                'Mr. Vishnu Varadhan',
                'CEO, ATAL-PECF',
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('Development Team'),
              _buildDevelopmentTeam(),
            ],
          ),
        ),
      ),
    );
  }

  // Card style for the information sections
  Widget _buildInfoCard(String logoPath, String text) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(logoPath, width: 60, height: 60),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card with subtitle for guidance section
  Widget _buildInfoCardWithSubtitle(String logoPath, String name, String position) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(logoPath, width: 60, height: 60),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    position,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Development team card design
  Widget _buildDevelopmentTeam() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildLogo('assets/ptu-logo.png'),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Shefaoudeen Z',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Design Club of PTU',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            _buildLogo('assets/logo.png'),
          ],
        ),
      ),
    );
  }

  // Section header with custom style
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,  // Elegant blue for headers
        ),
      ),
    );
  }

  // Logo styling with soft shadow
  Widget _buildLogo(String logoPath) {
    return Image.asset(
      logoPath,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
    );
  }
}
