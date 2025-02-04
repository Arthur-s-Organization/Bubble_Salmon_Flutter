import 'package:bubble_salmon/repositories/conversation_repository.dart';
import 'package:bubble_salmon/services/conversation_service.dart';

class DependencyInjection {
  static final ApiConversationService conversationService =
      ApiConversationService();
  static final ConversationRepository conversationRepository =
      ConversationRepository(
    apiConversationService: conversationService,
  );
}
