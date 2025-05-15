import 'package:flutter/material.dart';
import './resourceCard.dart';

class ResourceSection extends StatelessWidget {
  const ResourceSection({super.key});

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
        ResourceCard(),
        SizedBox(height: 20,),
        ResourceCard(),

      ],
    );
  }
}
