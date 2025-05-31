import 'package:flutter/material.dart';
import './resourceCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../webview.dart'; // Add this import

class ResourceSection extends StatelessWidget {
  const ResourceSection({super.key});

  // Add this method to handle navigation
  void _navigateToResource(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ArticleWebView(url: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore by Category',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(255, 255, 255, 0.85),
          ),
        ),
        SizedBox(height: 23),
        // Web Development
        GestureDetector(
          onTap:
              () => _navigateToResource(
                context,
                'https://developer.mozilla.org/en-US/docs/Learn',
              ),
          child: ResourceCard(
            title: 'Web Development',
            icon: FontAwesomeIcons.globe,
            iconColor: Color.fromRGBO(66, 153, 225, 1),
          ),
        ),
        SizedBox(height: 20),
        // Mobile Development
        GestureDetector(
          onTap: () => _navigateToResource(context, 'https://flutter.dev/docs'),
          child: ResourceCard(
            title: 'Mobile Development',
            icon: FontAwesomeIcons.mobile,
            iconColor: Color.fromRGBO(72, 187, 120, 1),
          ),
        ),
        SizedBox(height: 20),
        // Machine Learning & AI
        GestureDetector(
          onTap:
              () => _navigateToResource(
                context,
                'https://developers.google.com/machine-learning',
              ),
          child: ResourceCard(
            title: 'Machine Learning & AI',
            icon: FontAwesomeIcons.brain,
            iconColor: Color.fromRGBO(237, 100, 166, 1),
          ),
        ),
        SizedBox(height: 20),
        // Cloud Computing
        GestureDetector(
          onTap:
              () => _navigateToResource(
                context,
                'https://aws.amazon.com/getting-started',
              ),
          child: ResourceCard(
            title: 'Cloud Computing',
            icon: FontAwesomeIcons.cloud,
            iconColor: Color.fromRGBO(159, 122, 234, 1),
          ),
        ),
        SizedBox(height: 20),
        // Cybersecurity
        GestureDetector(
          onTap: () => _navigateToResource(context, 'https://www.cybrary.it'),
          child: ResourceCard(
            title: 'Cybersecurity',
            icon: FontAwesomeIcons.shield,
            iconColor: Color.fromRGBO(246, 173, 85, 1),
          ),
        ),
        SizedBox(height: 20),
        // Backend Development
        GestureDetector(
          onTap:
              () => _navigateToResource(context, 'https://nodejs.org/en/docs'),
          child: ResourceCard(
            title: 'Backend Development',
            icon: FontAwesomeIcons.server,
            iconColor: Color.fromRGBO(237, 137, 54, 1),
          ),
        ),
      ],
    );
  }
}
