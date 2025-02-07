import 'package:bubble_salmon/class/conversation.dart';
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
          "message": response["body"]["message"] ??
              "Erreur lors de la récupération des conversations",
          "conversations": [],
        };
      }
      final List<Conversation> conversations =
          Conversation.listFromJson(response["body"]);

      return {
        "status": "success",
        "message": "Conversations récupérées avec succès",
        "conversations": conversations,
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

  Future<Map<String, dynamic>> getConversationById(
      String conversationId) async {
    try {
      Map<String, dynamic> response =
          await apiConversationService.getConversationById(conversationId);
      if (response["statusCode"] != 200) {
        return {
          "status": "error",
          "message": response["body"]["message"] ??
              "Erreur lors de la récupération de la conversation",
          "conversation": null,
        };
      }

      final Conversation conversation = Conversation.fromJson(response["body"]);

      return {
        "status": "success",
        "message": "Conversation récupérée avec succès",
        "conversation": conversation,
      };
    } catch (e) {
      return {
        "status": "error",
        "message":
            "Erreur lors de la récupération de la conversation : ${e.toString()}",
        "conversations": null,
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
      // Vérifier qu'au moins l'un des deux paramètres est non null
      if (text == null && base64Image == null) {
        return {
          "status": "error",
          "message": "Le message doit contenir du texte ou une image",
        };
      }

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

  Future<Map<String, dynamic>> createGroup(
      String name, List<String> recipientIds, String? base64Image) async {
    try {
      final response = await apiConversationService.createGroup(
          name, recipientIds, base64Image);

      if (response["statusCode"] != 200) {
        return {
          "status": "error",
          "message": response["body"]["message"] ??
              "Erreur lors de la création du groupe",
        };
      }

      return {
        "status": "success",
        "message": "Groupe créé avec succès",
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Erreur lors de la création du groupe : ${e.toString()}",
      };
    }
  }

  // Dans conversation_repository.dart
  Future<Map<String, dynamic>> getOrCreateConversation(
      String recipientId) async {
    try {
      final response =
          await apiConversationService.getOrCreateConversation(recipientId);

      if (response["statusCode"] != 200) {
        return {
          "status": "error",
          "message": response["body"]["message"] ??
              "Erreur lors de la création de la conversation",
        };
      }

      return {
        "status": "success",
        "message": "Conversation récupérée/créée avec succès",
        "conversationId": response["body"]["id"],
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Erreur : ${e.toString()}",
      };
    }
  }
}
