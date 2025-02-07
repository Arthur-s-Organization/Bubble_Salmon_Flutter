import 'package:bubble_salmon/class/conversation.dart';
import 'package:bubble_salmon/class/message.dart';
import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/repositories/auth_repository.dart';
import 'package:bubble_salmon/repositories/conversation_repository.dart';
import 'package:bubble_salmon/widget/conversation/conversation_app_bar.dart';
import 'package:bubble_salmon/widget/conversation/message_input_bar.dart';
import 'package:bubble_salmon/widget/conversation/message_bubble.dart';
import 'package:flutter/material.dart';
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
  Conversation? _conversation;
  String? currentUserId;
  bool _isLoading = false;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _loadMessages();
    _loadConversation();
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

  Future<void> _initializeUser() async {
    final result = await widget.authRepository.getUserId();
    if (result["status"] == "success") {
      setState(() {
        currentUserId = result["user"].toString();
      });
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

  Future<void> _handleSendMessage(String? text, String? base64Image) async {
    // Vérifier qu'au moins l'un des deux paramètres est non null
    if (text == null && base64Image == null) return;

    final result = await widget.conversationRepository
        .sendMessage(widget.conversationId, text, base64Image);
    if (result["status"] == "success") {
      await _loadMessages();
      _scrollToBottom();
    }
  }

  Future<void> _loadConversation() async {
    final response = await widget.conversationRepository
        .getConversationById(widget.conversationId);

    setState(() {
      _isLoading = false;
      if (response["status"] == "success") {
        _conversation = response["conversation"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        appBar: ConversationAppBar(
          conversation: _conversation,
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final messageDate =
                    DateTime.parse(message.createdAt.toString());

                bool showDateSeparator = index == 0 ||
                    DateTime.parse(_messages[index - 1].createdAt.toString())
                            .day !=
                        messageDate.day;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showDateSeparator)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          Global.formatDate(messageDate),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    MessageBubble(
                      message: message.text ?? '',
                      time: Global.formatTime(messageDate),
                      messageType: message.messageType,
                      bubbleType: message.userId == currentUserId
                          ? BubbleType.sender
                          : BubbleType.receiver,
                      imageUrl: message.imageRepository != null &&
                              message.imageFileName != null
                          ? Global.getImagePath(
                              message.imageRepository!, message.imageFileName!)
                          : null,
                      senderName: message.username,
                      isGroupe: _conversation?.type == 3,
                    ),
                  ],
                );
              },
            )),
            MessageInputBar(
              focusNode: _focusNode,
              onSendMessage: (text, base64Image) async {
                await _handleSendMessage(text, base64Image);
              },
            ),
          ],
        ),
      ),
    );
  }
}
