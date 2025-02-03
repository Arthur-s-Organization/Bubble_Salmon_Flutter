import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiAuthService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    String url = "${dotenv.env['API_URL']}/User/login";
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': "application/json",
      },
      body: jsonEncode({
        "Username": username,
        "Password": password,
      }),
    );

    return {"statusCode": response.statusCode, "body": response.body};
  }
}
