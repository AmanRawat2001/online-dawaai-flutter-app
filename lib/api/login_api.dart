import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:onlinedawai/constants/constants.dart'; // Import the ApiConstants class

class LoginApi {
  // Function to call the login API
  Future<bool> login(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}onestep-sign'), // Use the base URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        // Login successful
        return true;
      } else {
        // Handle unsuccessful response
        print('Error: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      return false;
    }
  }
}
