import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/repositories/conversation_repository.dart';
import 'package:bubble_salmon/services/conversation_service.dart';
import 'package:bubble_salmon/widget/action_bar.dart';
import 'package:bubble_salmon/widget/bottom_bar.dart';
import 'package:bubble_salmon/widget/conversation_preview.dart';
import 'package:bubble_salmon/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _conversations = [];
  bool _isLoading = true;
  String? _errorMessage;
  final ConversationRepository _conversationRepository =
      ConversationRepository(apiConversationService: ApiConversationService());

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final response = await _conversationRepository.conversationsPreview();

    setState(() {
      _isLoading = false;

      if (response["status"] == "success") {
        _conversations = response["conversations"];
      } else {
        _errorMessage = response["message"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Loader
          : _conversations.isEmpty
              ? const Center(
                  // Placeholder si aucune conversation
                  child: Text(
                    "Aucune conversation pour le moment.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 12),
                  itemCount: _conversations.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: ActionBar(),
                      );
                    }
                    final conversation = _conversations[index - 1];
                    return InkWell(
                      child: ConversationPreview(
                        name:
                            conversation["name"] ?? "Pas de nom pour l'instant",
                        message: conversation["last_message"]?["text"] ??
                            "Aucun message", // Get text from last_message
                        time: Global.formatTime(DateTime.parse(
                            conversation?["last_message"]["createdAt"] ??
                                ["createdAt"])), // Parse createdAt
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/conversation',
                        arguments: {
                          'conversationId': conversation["id"].toString()
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                ),
      bottomNavigationBar: BottomBar(currentIndex: 1, context: context),
    );
  }
}
