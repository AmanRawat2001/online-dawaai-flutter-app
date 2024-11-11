import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onlinedawai/constants/constants.dart'; // Import the ApiConstants class

// API call to fetch product data by ID
Future<Map<String, dynamic>> fetchData(int id) async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}products/$id'), // Use the base URL
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data ?? {}; // Return the data if available, else empty map
    } else {
      throw Exception('Failed to load product data');
    }
  } catch (e) {
    throw Exception('Error fetching data: $e');
  }
}
