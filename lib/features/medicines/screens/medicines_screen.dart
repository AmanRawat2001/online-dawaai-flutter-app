import 'package:flutter/material.dart';
class MedicinesScreen extends StatefulWidget {
  final String token;
  final int id;
  const MedicinesScreen({super.key, required this.token, required this.id});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Text('Medicines Screen'),
      ),
    );
  }
}
