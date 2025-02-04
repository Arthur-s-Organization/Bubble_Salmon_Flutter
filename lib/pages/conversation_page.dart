import 'dart:convert';
import 'package:bubble_salmon/class/conversation.dart';
import 'package:bubble_salmon/repositories/conversation_repository.dart';
import 'package:bubble_salmon/widget/conversation/conversation_app_bar.dart';
import 'package:bubble_salmon/widget/conversation/message_input_bar.dart';
import 'package:bubble_salmon/widget/conversation/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ConversationPage extends StatefulWidget {
  final String conversationId;
  final ConversationRepository conversationRepository;

  const ConversationPage({
    super.key,
    required this.conversationId,
    required this.conversationRepository,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final FocusNode _focusNode = FocusNode();
  List<Message> _messages = [];
  String? currentUserId; // À récupérer depuis votre système d'authentification

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final result =
        await widget.conversationRepository.getMessages(widget.conversationId);
    if (result["status"] == "success") {
      setState(() {
        _messages = result["messages"];
      });
    }
  }

  Future<void> _handleSendMessage(String message) async {
    final result = await widget.conversationRepository
        .sendMessage(widget.conversationId, message, null);
    if (result["status"] == "success") {
      _loadMessages();
    }
  }

  Future<void> _handleImageSelected(XFile image) async {
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);
    final result = await widget.conversationRepository
        .sendMessage(widget.conversationId, null, base64Image);
    if (result["status"] == "success") {
      _loadMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        appBar: const ConversationAppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return MessageBubble(
                    message: message.text ?? '',
                    time: message.createdAt.toString(),
                    messageType: message.messageType,
                    bubbleType: message.userId == currentUserId
                        ? BubbleType.sender
                        : BubbleType.receiver,
                    imageUrl: message.imageUrl,
                  );
                },
              ),
            ),
            MessageInputBar(
              focusNode: _focusNode,
              onSendMessage: _handleSendMessage,
              onImageSelected: _handleImageSelected,
            ),
          ],
        ),
      ),
    );
  }
}
