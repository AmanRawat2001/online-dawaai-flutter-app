import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onlinedawai/constants/constants.dart';

Future<List<dynamic>> fetchProducts() async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}products'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error fetching data: $e');
  }
}
