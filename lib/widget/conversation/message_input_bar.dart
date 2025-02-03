import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MessageInputBar extends StatefulWidget {
  final void Function(String)? onSendMessage;
  final void Function(XFile)? onImageSelected;
  final FocusNode? focusNode;

  const MessageInputBar({
    super.key,
    this.onSendMessage,
    this.onImageSelected,
    this.focusNode,
  });

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _showImageSourceDialog() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Prendre une photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? photo =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null && widget.onImageSelected != null) {
                    widget.onImageSelected!(photo);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir depuis la galerie'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null && widget.onImageSelected != null) {
                    widget.onImageSelected!(image);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
              onPressed: _showImageSourceDialog,
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
