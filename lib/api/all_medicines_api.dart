import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onlinedawai/constants/constants.dart';

class AllMedicinesApi {
  Future<Map<String, dynamic>> fetchProducts({String? url}) async {
    try {
      final response = await http.get(
        Uri.parse(url ?? '${ApiConstants.baseUrl}products'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'data': data['data'] ?? [],
          'next_page_url': data['next_page_url'],
        };
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
