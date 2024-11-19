import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onlinedawai/constants/constants.dart';

class OrderStoreApi {
  Future<Map<String, dynamic>?> orderstore(
      Map<String, dynamic> shippingInfo, String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: jsonEncode(shippingInfo),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        return {'status': 'error', 'message': errorData['message']};
      }
    } catch (e) {
      return null;
    }
  }
}
