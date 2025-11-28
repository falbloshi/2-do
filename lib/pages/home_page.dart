import 'package:flutter/material.dart';

Map<String, List<String>> notesData = {
  'Shopping List': ['Milk', 'Eggs', 'Bread', 'Cheese'],
  'Meeting Minutes': [
    'Discussed Q3 results.',
    'Agreed on new marketing strategy.',
    'Follow-up: Contact vendor X.',
  ],
  'Travel Checklist': ['Passport', 'Tickets', 'Chargers'],
};

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomePage());
  }
}
