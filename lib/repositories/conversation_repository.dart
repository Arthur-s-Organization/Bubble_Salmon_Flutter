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
}
