import 'package:bubble_salmon/widget/conversation_app_bar.dart';
import 'package:bubble_salmon/widget/message_input_bar.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final FocusNode _focusNode = FocusNode();

  void _handleSendMessage(String message) {
    // TODO: Implement send message logic
  }

  void _handleAttachment() {
    // TODO: Implement attachment logic
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: const ConversationAppBar(),
        body: Column(
          children: [
            const Expanded(
              child: SizedBox(), // Chat messages will go here
            ),
            MessageInputBar(
              focusNode: _focusNode,
              onSendMessage: _handleSendMessage,
              onAttachmentPressed: _handleAttachment,
            ),
          ],
        ),
      ),
    );
  }
}
