import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onlinedawai/constants/constants.dart';

Future<List<dynamic>> fetchBrands() async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}homepage'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['original']['brands'] ?? [];
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error fetching data: $e');
  }
}

Future<List<dynamic>> fetchFeatured() async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}homepage'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['original']['featured'] ?? [];
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error fetching data: $e');
  }
}

Future<List<dynamic>> fetchHotDeals() async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}homepage'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['original']['hot_deals'] ?? [];
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error fetching data: $e');
  }
}

Future<List<dynamic>> fetchSpecialOffer() async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}homepage'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['original']['special_offer'] ?? [];
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error fetching data: $e');
  }
}

Future<List<dynamic>> fetchSpecialDeals() async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}homepage'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['original']['special_deals'] ?? [];
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error fetching data: $e');
  }
}

Future<List<dynamic>> fetchSliders() async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}homepage'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['original']['sliders'] ?? [];
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error fetching data: $e');
  }
}

Future<List<dynamic>> fetchTitles() async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}homepage'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> titleList = data['data']['original']['titles'] ?? [];
      return titleList.map<String>((item) => item['title'] as String).toList();
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error fetching data: $e');
  }
}
