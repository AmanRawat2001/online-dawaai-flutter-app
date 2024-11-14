import 'package:flutter/material.dart';

class HealthcareScreen extends StatefulWidget {
  final String token;
  final int id;
  const HealthcareScreen({super.key, required this.token, required this.id});

  @override
  State<HealthcareScreen> createState() => _HealthcareScreenState();
}

class _HealthcareScreenState extends State<HealthcareScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Text('Comming Soon'),
      ),
    );
  }
}
