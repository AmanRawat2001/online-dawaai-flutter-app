import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:onlinedawai/features/healthcare/screens/healthcare_screen.dart';
import 'package:onlinedawai/features/home/screens/home_screen.dart';
import 'package:onlinedawai/features/labtests/screens/labtests_screen.dart';
import 'package:onlinedawai/widgets/custom_appbar.dart';
import 'package:onlinedawai/features/medicines/screens/medicines_screen.dart';
import 'package:onlinedawai/features/carts/screens/cart_screen.dart';

class BottomNavBar extends StatefulWidget {
  final String token;
  final int id;
  const BottomNavBar({super.key, required this.token, this.id = 0});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  int? _currentId = 0;
  @override
  void initState() {
    super.initState();
    _currentId = widget.id;
  }

  void _handleNavItemTap(int index) {
    setState(() {
      _isLoading = true;
      _selectedIndex = index;
      if (index != 2) {
        _currentId = 0;
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  Widget _getBodyContent() {
    switch (_selectedIndex) {
      case 0:
        if (_currentId == 1) {
          return MedicinesScreen(token: widget.token, id: _currentId ?? 0);
        }
        if (_currentId == 2) {
          return LabtestsScreen(token: widget.token, id: _currentId ?? 0);
        }
        if (_currentId == 3) {
          return HealthcareScreen(token: widget.token, id: _currentId ?? 0);
        }
        return HomeScreen(token: widget.token);
      case 1:
        return CartScreen(token: widget.token);
      case 2:
        return const Center(child: Text('CompareItemsScreen'));
      default:
        return const Center(child: Text('Unknown Screen'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        token: widget.token,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _getBodyContent(),
      bottomNavigationBar: CurvedNavigationBar(
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: _selectedIndex == 0
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurface,
          ),
          Icon(
            Icons.shopping_cart,
            size: 30,
            color: _selectedIndex == 1
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurface,
          ),
          Icon(
            Icons.settings,
            size: 30,
            color: _selectedIndex == 2
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurface,
          ),
        ],
        onTap: _handleNavItemTap,
      ),
    );
  }
}
