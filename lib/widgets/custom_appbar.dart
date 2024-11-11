import 'package:flutter/material.dart';
import 'package:onlinedawai/api/logout_api.dart';
import 'package:onlinedawai/utils/token_storage.dart';
import 'package:onlinedawai/features/auth/screens/login_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String token;

  const CustomAppBar({
    super.key,
    required this.token,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 40,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ONLINE DAWAAI',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                'Powered By Gulati bros',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.logout,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => _confirmLogout(context),
        ),
      ],
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    bool? shouldLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            'Logout Confirmation',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
    if (shouldLogout == true) {
      _logout(context);
    }
  }

  Future<void> _logout(BuildContext context) async {
    bool isLoggedOut = await LogoutApi().logout(token);
    if (isLoggedOut) {
      await TokenStorage.clearToken();
      _navigateToLogin(context);
    } else {
      // Show a SnackBar using the current context before navigating away
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  void _navigateToLogin(BuildContext context) {
    // Ensure that the SnackBar is shown before navigating
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }
}
