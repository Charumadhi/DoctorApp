import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsPage extends StatelessWidget {
  final String jwtToken;

  CreditsPage({required this.jwtToken});

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
        backgroundColor: Colors.indigo[600],
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, jwtToken);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFd1c4e9),
              Color(0xFFffffff),
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
              _buildInfoCard(
                'assets/aic_logo.png',
                'Mr. Vishnu Varadhan',
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }

  Widget _buildDevelopmentTeam() {
    return Column(
      children: [
        _buildDeveloperCard(
          'Shefaoudeen Z',
          ['assets/ptu-logo.png', 'assets/logo.png'], // Two images for Shefaoudeen
          'https://www.linkedin.com/in/shefaoudeen-z/',
          'https://github.com/Shefaoudeen',
          'Web Development',
        ),
        const SizedBox(height: 16),
        _buildDeveloperCard(
          'Pradeep Raj',
          ['assets/ptu-logo.png','assets/logo.png'], // Single image
          'https://www.linkedin.com/in/pradheepraj/',
          'https://github.com/Pradheepraj2K4',
          'Backend Development',
        ),
        const SizedBox(height: 16),
        _buildDeveloperCard(
          'Paul Jenniffer',
          ['assets/ptu-logo.png'], // Single image
          'https://www.linkedin.com/in/jenniffer-paul-1a64a7215/',
          'https://github.com/JennifferPaul',
          'Mobile App Development',
        ),
        const SizedBox(height: 16),
        _buildDeveloperCard(
          'Charumadhi',
          ['assets/ptu-logo.png'], // Single image
          'https://www.linkedin.com/in/charumadhi-t-315abb278/',
          'https://github.com/Charumadhi',
          'Mobile App Development',
        ),
      ],
    );
  }

  Widget _buildDeveloperCard(
      String name,
      List<String> logoPaths,
      String linkedInUrl,
      String githubUrl,
      String workDescription, // Description of the work done
      ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // First logo on the left
            _buildLogo(logoPaths.first),
            const SizedBox(width: 12),
            // Developer details and social links
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
                  const SizedBox(height: 8),
                  // Description of the work done by the person
                  Text(
                    workDescription,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSocialIcon(FontAwesomeIcons.linkedin, linkedInUrl),
                      const SizedBox(width: 16),
                      _buildSocialIcon(FontAwesomeIcons.github, githubUrl),
                    ],
                  ),
                ],
              ),
            ),
            // Second logo on the right
            if (logoPaths.length > 1)
              _buildLogo(logoPaths.last),
          ],
        ),
      ),
    );
  }



  Widget _buildLogo(String logoPath) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Image.asset(
        logoPath,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return IconButton(
      icon: Icon(icon, size: 30, color: Colors.indigo),
      onPressed: () async {
        await _launchURL(url);
      },
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
