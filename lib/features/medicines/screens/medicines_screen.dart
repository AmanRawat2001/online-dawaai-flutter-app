import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:onlinedawai/features/medicines/screens/medicinescreen_content.dart';
import 'package:onlinedawai/features/medicines/widgets/medicines_search_delegate.dart';

class MedicinesScreen extends StatefulWidget {
  final String token;
  final int id;
  const MedicinesScreen({super.key, required this.token, required this.id});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? const MedicinesSearchDelegate()
            : const Text('Medicines'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Apply the blur effect as soon as _isSearching is true
          if (_isSearching)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Optional dark overlay
                ),
              ),
            ),
          MedicinescreenContent(token: widget.token),
        ],
      ),
    );
  }
}
