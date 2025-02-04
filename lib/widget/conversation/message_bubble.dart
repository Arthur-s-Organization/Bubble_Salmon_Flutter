import 'package:bubble_salmon/class/conversation.dart';
import 'package:flutter/material.dart';

enum BubbleType { sender, receiver }

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final MessageType messageType;
  final BubbleType bubbleType;
  final String? imageUrl;

  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.messageType,
    required this.bubbleType,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: bubbleType == BubbleType.sender
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bubbleType == BubbleType.sender
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (messageType == MessageType.image && imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            if (message.isNotEmpty)
              Container(
                margin: messageType == MessageType.image
                    ? const EdgeInsets.only(top: 8)
                    : EdgeInsets.zero,
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
