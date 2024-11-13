import 'package:flutter/material.dart';

class LabtestsScreen extends StatefulWidget {
  final String token;
  final int id;
  const LabtestsScreen({super.key, required this.token, required this.id});

  @override
  State<LabtestsScreen> createState() => _LabtestsScreenState();
}

class _LabtestsScreenState extends State<LabtestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Text('LabTestsScreen'),
      ),
    );
  }
}
