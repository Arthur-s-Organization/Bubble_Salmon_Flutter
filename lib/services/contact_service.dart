import 'dart:convert';
import 'package:bubble_salmon/global/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiContactService {
  Future<Map<String, dynamic>> getContacts() async {
    String url = "${dotenv.env['API_URL']}/User/getAll";
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
