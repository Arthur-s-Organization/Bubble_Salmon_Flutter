import 'package:bubble_salmon/class/conversation.dart';
import 'package:bubble_salmon/class/message.dart';
import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/repositories/auth_repository.dart';
import 'package:bubble_salmon/repositories/conversation_repository.dart';
import 'package:bubble_salmon/widget/conversation/conversation_app_bar.dart';
import 'package:bubble_salmon/widget/conversation/message_bubble.dart';
// Import the MessageInputBar widget
import 'package:bubble_salmon/widget/conversation/message_input_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// Extension pour éviter la duplication de code
extension MessageListComparison on List<Message> {
  bool hasChanged(List<Message> other) {
    if (length != other.length) return true;
    for (int i = 0; i < length; i++) {
      if (this[i].id != other[i].id ||
          this[i].createdAt != other[i].createdAt ||
          this[i].text != other[i].text) {
        return true;
      }
    }
    return false;
  }
}

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
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  Conversation? _conversation;
  String? currentUserId;
  bool _isLoading = false;
  bool _isInitialLoad = true;
  final FocusNode _messageFocusNode = FocusNode();

  // StreamController pour gérer les mises à jour des messages
  final StreamController<List<Message>> _messagesStreamController =
      StreamController<List<Message>>.broadcast();

  // Timer pour le rafraîchissement périodique
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _loadConversation();
    _initialLoadMessages();

    // Configurer le timer pour mettre à jour uniquement le stream
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _refreshMessages();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _scrollController.dispose();
    _messagesStreamController.close();
    _messageFocusNode.dispose();
    super.dispose();
  }

  Future<void> _initializeUser() async {
    final result = await widget.authRepository.getUserId();
    if (result["status"] == "success") {
      setState(() {
        currentUserId = result["user"].toString();
      });
    }
  }

  // Chargement initial des messages (avec setState)
  Future<void> _initialLoadMessages() async {
    if (_isLoading) return;

    _isLoading = true;
    try {
      final result = await widget.conversationRepository
          .getMessages(widget.conversationId);
      if (result["status"] == "success") {
        final messages = List<Message>.from(result["messages"])
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

        setState(() {
          _messages = messages;
        });

        // Émettre également les messages dans le stream
        _messagesStreamController.add(messages);

        if (_isInitialLoad) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
            _isInitialLoad = false;
          });
        }
      }
    } finally {
      _isLoading = false;
    }
  }

  // Rafraîchissement des messages (sans setState, uniquement via stream)
  Future<void> _refreshMessages() async {
    if (_isLoading) return;

    _isLoading = true;
    try {
      final result = await widget.conversationRepository
          .getMessages(widget.conversationId);
      if (result["status"] == "success") {
        final newMessages = List<Message>.from(result["messages"])
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

        // Vérifier si les messages ont changé
        if (_messages.hasChanged(newMessages)) {
          _messages = newMessages;
          // Mettre à jour uniquement le stream, pas l'état
          _messagesStreamController.add(newMessages);

          // Si de nouveaux messages sont arrivés, défiler vers le bas
          if (newMessages.length > _messages.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
        }
      }
    } finally {
      _isLoading = false;
    }
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

  Future<void> _loadConversation() async {
    final response = await widget.conversationRepository
        .getConversationById(widget.conversationId);

    setState(() {
      if (response["status"] == "success") {
        _conversation = response["conversation"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        appBar: ConversationAppBar(
          conversation: _conversation,
          onConversationUpdated: () {
            _loadConversation();
          },
        ),
        body: Column(
          children: [
            // Zone des messages qui sera mise à jour par le stream
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: _messagesStreamController.stream,
                initialData: _messages,
                builder: (context, snapshot) {
                  final messages = snapshot.data ?? [];
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final messageDate =
                          DateTime.parse(message.createdAt.toString());

                      bool showDateSeparator = index == 0 ||
                          DateTime.parse(
                                      messages[index - 1].createdAt.toString())
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
                                ? Global.getImagePath(message.imageRepository!,
                                    message.imageFileName!)
                                : null,
                            senderName: message.username,
                            isGroupe: _conversation?.type == 3,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            // Remplacer CustomInputBar par MessageInputBar
            MessageInputBar(
              onSendMessage: (text, base64Image) async {
                await _handleSendMessage(text, base64Image);
              },
              focusNode: _messageFocusNode,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSendMessage(String? text, String? base64Image) async {
    if (text == null && base64Image == null) return;

    final result = await widget.conversationRepository
        .sendMessage(widget.conversationId, text, base64Image);
    if (result["status"] == "success") {
      // Forcer un rafraîchissement immédiat
      await _refreshMessages();
      _scrollToBottom();
    }
  }
}
