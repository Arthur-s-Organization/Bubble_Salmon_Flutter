import 'package:flutter/material.dart';

class MessageInputBar extends StatefulWidget {
  final void Function(String)? onSendMessage;
  final VoidCallback? onAttachmentPressed;
  final FocusNode? focusNode;

  const MessageInputBar({
    super.key,
    this.onSendMessage,
    this.onAttachmentPressed,
    this.focusNode,
  });

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.onSendMessage?.call(message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon:
                  Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              onPressed: widget.onAttachmentPressed,
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                focusNode: widget.focusNode,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  border: InputBorder.none,
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: _handleSendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
