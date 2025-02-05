import 'dart:convert';
import 'package:bubble_salmon/class/message.dart';
import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/repositories/auth_repository.dart';
import 'package:bubble_salmon/repositories/conversation_repository.dart';
import 'package:bubble_salmon/widget/conversation/conversation_app_bar.dart';
import 'package:bubble_salmon/widget/conversation/message_input_bar.dart';
import 'package:bubble_salmon/widget/conversation/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class ConversationPage extends StatefulWidget {
  final String conversationId;
  final ConversationRepository conversationRepository;
  final AuthRepository authRepository;

  const ConversationPage({
    super.key,
    required this.conversationId,
    required this.conversationRepository,
    required this.authRepository,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  Timer? _refreshTimer;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController =
      ScrollController(); // Add ScrollController
  List<Message> _messages = [];
  String? currentUserId;
  bool _isLoading = false;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _loadMessages();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _focusNode.dispose();
    _scrollController.dispose(); // Dispose ScrollController
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _loadMessages() async {
    if (_isLoading) return;

    _isLoading = true;
    try {
      final result = await widget.conversationRepository
          .getMessages(widget.conversationId);
      if (result["status"] == "success") {
        setState(() {
          _messages = List<Message>.from(result["messages"])
            ..sort(
                (Message a, Message b) => a.createdAt.compareTo(b.createdAt));
        });

        // On ne scrolle que lors du chargement initial
        if (_isInitialLoad) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
            _isInitialLoad =
                false; // On marque le chargement initial comme terminé
          });
        }
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _handleSendMessage(String message) async {
    final result = await widget.conversationRepository
        .sendMessage(widget.conversationId, message, null);
    if (result["status"] == "success") {
      await _loadMessages();
      _scrollToBottom(); // Scroll after sending message
    }
  }

  Future<void> _handleImageSelected(XFile image) async {
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);
    final result = await widget.conversationRepository
        .sendMessage(widget.conversationId, null, base64Image);
    if (result["status"] == "success") {
      await _loadMessages();
      _scrollToBottom(); // Scroll after sending image
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
                controller: _scrollController, // Add controller to ListView
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return MessageBubble(
                    message: message.text ?? '',
                    time: Global.formatTime(
                        DateTime.parse(message.createdAt.toString())),
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
