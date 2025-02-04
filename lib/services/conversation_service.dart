import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiConversationService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> conversationsPreview() async {
    String url = "${dotenv.env['API_URL']}/Conversation/getAll";
    String? token = await storage.read(key: "jwt_token");

    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        'Content-Type': "application/json",
      },
    );
    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }

  Future<Map<String, dynamic>> getMessages(String conversationId) async {
    String url = "${dotenv.env['API_URL']}/Message/getAll/$conversationId";
    String? token = await storage.read(key: "jwt_token");

    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        'Content-Type': "application/json",
      },
    );
    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }

  Future<Map<String, dynamic>> sendMessage(
      String conversationId, String? text, String? base64Image) async {
    String url = "${dotenv.env['API_URL']}/Message/Add";
    String? token = await storage.read(key: "jwt_token");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        'Content-Type': "application/json",
      },
      body: jsonEncode({
        "conversationId": conversationId,
        if (text != null) "text": text,
        if (base64Image != null) "image": base64Image,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }
}
