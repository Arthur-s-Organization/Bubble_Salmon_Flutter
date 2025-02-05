import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiContactService {
  Future<Map<String, dynamic>> getContacts(String token) async {
    String url = "${dotenv.env['API_URL']}/User/getAll";
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': "application/json",
      },
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }
}
