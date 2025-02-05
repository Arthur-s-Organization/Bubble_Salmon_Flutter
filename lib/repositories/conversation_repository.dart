import 'package:bubble_salmon/class/message.dart';
import 'package:bubble_salmon/services/conversation_service.dart';

class ConversationRepository {
  final ApiConversationService apiConversationService;

  const ConversationRepository({
    required this.apiConversationService,
  });

  Future<Map<String, dynamic>> conversationsPreview() async {
    try {
      Map<String, dynamic> response =
          await apiConversationService.conversationsPreview();

      if (response["statusCode"] != 200) {
        return {
          "status": "error",
          "message": response["body"]["message"] ?? "Erreur inconnue",
          "conversations": [],
        };
      }

      return {
        "status": "success",
        "message": "Conversations récupérées",
        "conversations": response["body"],
      };
    } catch (e) {
      return {
        "status": "error",
        "message":
            "Erreur lors de la récupération des conversations : ${e.toString()}",
        "conversations": [],
      };
    }
  }

  Future<Map<String, dynamic>> getMessages(String conversationId) async {
    try {
      final response = await apiConversationService.getMessages(conversationId);

      if (response["statusCode"] != 200) {
        return {
          "status": "error",
          "message": response["body"]["message"] ?? "Erreur inconnue",
          "messages": [],
        };
      }
      final List<Message> messages = (response["body"] as List)
          .map((json) => Message.fromJson(json))
          .toList();
      return {
        "status": "success",
        "message": "Messages récupérés",
        "messages": messages,
      };
    } catch (e) {
      return {
        "status": "error",
        "message":
            "Erreur lors de la récupération des messages : ${e.toString()}",
        "messages": [],
      };
    }
  }

  Future<Map<String, dynamic>> sendMessage(
      String conversationId, String? text, String? base64Image) async {
    try {
      final response = await apiConversationService.sendMessage(
          conversationId, text, base64Image);

      if (response["statusCode"] != 200) {
        return {
          "status": "error",
          "message": response["body"]["message"] ?? "Erreur inconnue",
        };
      }

      return {
        "status": "success",
        "message": "Message envoyé",
        "messageData": Message.fromJson(response["body"]),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Erreur lors de l'envoi du message : ${e.toString()}",
      };
    }
  }
}
