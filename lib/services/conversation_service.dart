import 'dart:convert';

import 'package:bubble_salmon/global/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiConversationService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> conversationsPreview() async {
    String url = "${dotenv.env['API_URL']}/Conversation/getAll";

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

  Future<Map<String, dynamic>> getConversationById(
      String conversationId) async {
    String url = "${dotenv.env['API_URL']}/Conversation/show/$conversationId";

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

  Future<Map<String, dynamic>> getMessages(String conversationId) async {
    String url = "${dotenv.env['API_URL']}/Message/getAll/$conversationId";

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

  Future<Map<String, dynamic>> sendMessage(
      String conversationId, String? text, String? base64Image) async {
    String url = "${dotenv.env['API_URL']}/Message/Add";

    final response = await Global.httpClient.post(
      Uri.parse(url),
      headers: {
        'Content-Type': "application/json",
      },
      body: jsonEncode({
        "ConversationId": conversationId,
        if (text != null) "Text": text,
        if (text == null) "Text": null,
        if (base64Image != null) "Image": base64Image,
      }),
    );
    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }

  // Dans conversation_service.dart
  Future<Map<String, dynamic>> createGroup(
      String name, List<String> recipientIds, String? base64Image) async {
    String url = "${dotenv.env['API_URL']}/Conversation/addGroup";

    final response = await Global.httpClient.post(
      Uri.parse(url),
      headers: {
        'Content-Type': "application/json",
      },
      body: jsonEncode({
        "Name": name,
        "RecipientIds": recipientIds,
        if (base64Image != null) "Image": base64Image,
        if (base64Image == null) "Image": null,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }

  // Dans conversation_service.dart
  Future<Map<String, dynamic>> getOrCreateConversation(
      String recipientId) async {
    String url = "${dotenv.env['API_URL']}/Conversation/getOrCreate";

    final response = await Global.httpClient.post(
      Uri.parse(url),
      headers: {
        'Content-Type': "application/json",
      },
      body: jsonEncode({
        "RecipientId": recipientId,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }
}
