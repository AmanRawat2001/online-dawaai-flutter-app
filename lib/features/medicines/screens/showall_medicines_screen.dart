import 'package:flutter/material.dart';

class ShowallMedicinesScreen extends StatefulWidget {
  final String query;
  const ShowallMedicinesScreen({super.key, required this.query});

  @override
  State<ShowallMedicinesScreen> createState() => _ShowallMedicinesScreenState();
}

class _ShowallMedicinesScreenState extends State<ShowallMedicinesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("this is the show all screen${widget.query}")),
    );
  }
}
