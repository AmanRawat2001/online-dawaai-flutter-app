import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:onlinedawai/constants/constants.dart';
import 'package:onlinedawai/utils/token_storage.dart';

class VerificationApi {
  // Function to call the login API
  Future<String?> verification(String phone, String otp) async {
    try {
      print('Verifying OTP...');
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}verify-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final originalData = responseData['data']['original'];

        if (originalData['status'] == 'success') {
          final String token = originalData['token'];
          print('Verification successful');
          print('Token: $token');

          // Save the token to SharedPreferences
          await TokenStorage.saveToken(token);
          // Return the token
          return token;
        } else if (originalData['status'] == 'error') {
          // Login failed, print the error message
          print('Login failed: ${originalData['message']}');
          return null;
        }
      } else if (response.statusCode == 401) {
        // Handle 401 Unauthorized error
        print('Error 401: Unauthorized - Invalid credentials.');
        return null;
      } else {
        // Handle other unsuccessful responses
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      return null;
    }
    return null;
  }
}
