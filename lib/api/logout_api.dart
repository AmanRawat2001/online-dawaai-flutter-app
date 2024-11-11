import 'package:http/http.dart' as http;
import 'package:onlinedawai/constants/constants.dart'; // Import the ApiConstants class

class LogoutApi {
  Future<bool> logout(String token) async {
    try {
      print('Token: $token');
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}logout'), // Use the base URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        // Logout successful
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
