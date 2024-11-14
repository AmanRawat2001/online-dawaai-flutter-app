import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onlinedawai/constants/constants.dart';

class ProductSearchApi {
  Future<List<dynamic>> searchProducts(String? name) async {
    // Ensure the name is not null or empty before making the request
    if (name == null || name.isEmpty) {
      throw Exception('Search query cannot be empty');
    }

    try {
      // ignore: avoid_print
      print('Fetching products for search query: $name');
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}products/serach?medicine=$name'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if 'data' and 'original' exist in the response
        final productList = data['data']?['original'] ?? [];

        if (productList.isEmpty) {
          // ignore: avoid_print
          print('No products found for the search query: $name');
        }

        return productList;
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log the actual error message for better debugging
      throw Exception('Error fetching data: $e');
    }
  }
  Future<List<dynamic>> showAllSearchProduct(String? name) async {
    // Ensure the name is not null or empty before making the request
    if (name == null || name.isEmpty) {
      throw Exception('Search query cannot be empty');
    }

    try {
      // ignore: avoid_print
      print('Fetching products for search query: $name');
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}products/serach?all=$name&medicine=$name'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if 'data' and 'original' exist in the response
        final productList = data['data']?['original'] ?? [];

        if (productList.isEmpty) {
          // ignore: avoid_print
          print('No products found for the search query: $name');
        }

        return productList;
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log the actual error message for better debugging
      throw Exception('Error fetching data: $e');
    }
  }
  

}
