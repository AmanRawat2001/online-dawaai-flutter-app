import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:onlinedawai/features/home/screens/home_screen.dart';
import 'package:onlinedawai/features/product/product_screen.dart';
import 'package:onlinedawai/widgets/custom_appbar.dart';

class BottomNavBar extends StatefulWidget {
  final String token;
  const BottomNavBar({super.key, required this.token});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  void _handleNavItemTap(int index) {
    setState(() {
      _isLoading = true;
      _selectedIndex = index;
    });

    setState(() {
      _isLoading = false;
    });
  }

  Widget _getBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen(token: widget.token);
      case 1:
        return const ProductScreen();
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
