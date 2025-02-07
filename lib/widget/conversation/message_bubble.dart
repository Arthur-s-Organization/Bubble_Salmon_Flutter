import 'package:bubble_salmon/class/message.dart';
import 'package:flutter/material.dart';

enum BubbleType { sender, receiver }

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final MessageType messageType;
  final BubbleType bubbleType;
  final String? imageUrl;
  final String? senderName;
  final bool isGroupe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.messageType,
    required this.bubbleType,
    required this.isGroupe,
    this.imageUrl,
    this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSender = bubbleType == BubbleType.sender;

    final bubbleColor =
        isSender ? theme.colorScheme.primary : theme.colorScheme.secondary;
    final textColor = Colors.black87;
    final timeColor = Colors.black54;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          left: isSender ? 64 : 8,
          right: isSender ? 8 : 64,
          top: 4,
          bottom: 4,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isSender ? 16 : 4),
              bottomRight: Radius.circular(isSender ? 4 : 16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: isSender || !isGroupe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (!isSender && senderName != null && isGroupe)
                    Text(
                      senderName!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  Text(
                    time,
                    style: TextStyle(
                      color: timeColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              if (messageType == MessageType.image && imageUrl != null)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
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
                      color: textColor,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
