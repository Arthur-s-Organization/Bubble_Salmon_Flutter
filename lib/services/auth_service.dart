import 'dart:convert';
import 'package:bubble_salmon/global/utils.dart';
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

  Future<Map<String, dynamic>> register(
    String firstname,
    String lastname,
    String username,
    String password,
    String phone,
    String birthdate,
    String profilePicture,
  ) async {
    String url = "${dotenv.env['API_URL']}/User/register";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': "application/json",
      },
      body: jsonEncode({
        "Username": username,
        "Password": password,
        "Firstname": firstname,
        "Lastname": lastname,
        "Phone": phone,
        "BirthDate": birthdate,
        "Image": profilePicture,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }

  Future<Map<String, dynamic>> getUser() async {
    String url = "${dotenv.env['API_URL']}/User/show";
    final http.Response response = await Global.httpClient.get(
      Uri.parse(url),
      headers: {
        'Content-Type': "application/json",
      },
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }

  Future<Map<String, dynamic>> getUserId() async {
    String url = "${dotenv.env['API_URL']}/User/show";
    final http.Response response = await Global.httpClient.get(
      Uri.parse(url),
      headers: {
        'Content-Type': "application/json",
      },
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }
}
