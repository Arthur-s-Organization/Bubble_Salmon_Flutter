import 'package:bubble_salmon/widget/conversation/conversation_app_bar.dart';
import 'package:bubble_salmon/widget/conversation/message_input_bar.dart';
import 'package:bubble_salmon/widget/conversation/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final FocusNode _focusNode = FocusNode();

  // Example messages list
  final List<Map<String, dynamic>> _messages = [
    {
      'message': 'Hello!',
      'time': '09:02',
      'type': MessageType.text,
      'isSender': true,
    },
    {
      'message': 'Hi there!',
      'time': '09:02',
      'type': MessageType.text,
      'isSender': false,
    },
    {
      'message': 'Check out this image',
      'time': '09:02',
      'type': MessageType.image,
      'imageUrl':
          'https://static.vecteezy.com/ti/photos-gratuite/p2/30692160-saumon-2d-dessin-anime-vecteur-illustration-sur-blanc-contexte-gratuit-photo.jpg',
      'isSender': true,
    },
  ];

  void _handleSendMessage(String message) {
    // TODO: Implement send message logic
  }

  void _handleImageSelected(XFile image) {
    // TODO: Implement image handling logic
    setState(() {
      _messages.add({
        'message': '',
        'time': '09:02', // Use actual time
        'type': MessageType.image,
        'imageUrl': image.path,
        'isSender': true,
      });
    });
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
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return MessageBubble(
                    message: message['message'],
                    time: message['time'],
                    messageType: message['type'],
                    bubbleType: message['isSender']
                        ? BubbleType.sender
                        : BubbleType.receiver,
                    imageUrl: message['imageUrl'],
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
