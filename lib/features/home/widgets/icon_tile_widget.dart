import 'package:flutter/material.dart';
import 'package:onlinedawai/features/healthcare/screens/healthcare_screen.dart';
import 'package:onlinedawai/features/labtests/screens/labtests_screen.dart';
import 'package:onlinedawai/features/medicines/screens/medicines_screen.dart';

Widget buildIconTile(
    BuildContext context, String imagePath, String label, String token) {
  return GestureDetector(
    onTap: () {
      switch (label) {
        case 'Medicines':
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MedicinesScreen(token: token, id: 1)),
          );
          break;
        case 'Lab Tests':
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LabtestsScreen(token: token, id: 2)),
          );
          break;
        case 'Healthcare':
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HealthcareScreen(token: token, id: 3)),
          );
          break;
        default:
          // Add navigation for other categories
          break;
      }
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 0.3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
