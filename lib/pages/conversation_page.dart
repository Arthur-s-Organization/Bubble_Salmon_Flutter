import 'package:bubble_salmon/class/conversation.dart';
import 'package:bubble_salmon/class/message.dart';
import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/repositories/auth_repository.dart';
import 'package:bubble_salmon/repositories/conversation_repository.dart';

import 'package:bubble_salmon/widget/conversation/conversation_app_bar.dart';
import 'package:bubble_salmon/widget/conversation/message_bubble.dart';
import 'package:bubble_salmon/widget/conversation/message_input_bar.dart';
import 'package:bubble_salmon/widget/error_handler.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
  String? _errorMessage;
  final FocusNode _messageFocusNode = FocusNode();

  final StreamController<List<Message>> _messagesStreamController =
      StreamController<List<Message>>.broadcast();

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _loadConversation();
    _initialLoadMessages();

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
    try {
      final result = await widget.authRepository.getUserId();
      if (result["status"] == "success") {
        setState(() {
          currentUserId = result["user"].toString();
        });
      } else {}
    } catch (e) {}
  }

  Future<void> _initialLoadMessages() async {
    if (_isLoading) return;

    _isLoading = true;
    setState(() {
      _errorMessage = null;
    });

    try {
      final result = await widget.conversationRepository
          .getMessages(widget.conversationId);

      setState(() {
        _isLoading = false;
      });

      if (result["status"] == "success") {
        final messages = List<Message>.from(result["messages"])
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

        setState(() {
          _messages = messages;
        });

        _messagesStreamController.add(messages);

        if (_isInitialLoad) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
            _isInitialLoad = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = "Impossible de charger les messages";
        });
        ErrorHandler.showError(context,
            customMessage: "Impossible de charger les messages");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Impossible de charger les messages";
      });
      ErrorHandler.showError(context,
          customMessage:
              "Impossible de charger les messages. Vérifiez votre connexion internet.");
    }
  }

  Future<void> _refreshMessages() async {
    if (_isLoading) return;

    _isLoading = true;
    try {
      final result = await widget.conversationRepository
          .getMessages(widget.conversationId);

      if (result["status"] == "success") {
        final newMessages = List<Message>.from(result["messages"])
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

        if (_messages.hasChanged(newMessages)) {
          setState(() {
            _messages = newMessages;
            _errorMessage = null;
          });

          _messagesStreamController.add(newMessages);

          if (newMessages.length > _messages.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
        }
      } else {
        setState(() {
          _errorMessage = "Impossible de rafraîchir les messages";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Impossible de rafraîchir les messages";
      });
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
    try {
      final response = await widget.conversationRepository
          .getConversationById(widget.conversationId);

      if (response["status"] == "success") {
        setState(() {
          _conversation = response["conversation"];
        });
      } else {}
    } catch (e) {}
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
            Expanded(
              child: _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Impossible de charger les messages",
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _initialLoadMessages,
                            child: Text("Réessayer"),
                          ),
                        ],
                      ),
                    )
                  : StreamBuilder<List<Message>>(
                      stream: _messagesStreamController.stream,
                      initialData: _messages,
                      builder: (context, snapshot) {
                        if (_isInitialLoad && _isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final messages = snapshot.data ?? [];
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final messageDate =
                                DateTime.parse(message.createdAt.toString());

                            bool showDateSeparator = index == 0 ||
                                DateTime.parse(messages[index - 1]
                                            .createdAt
                                            .toString())
                                        .day !=
                                    messageDate.day;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (showDateSeparator)
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
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
                                          message.imageRepository!,
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

    try {
      final result = await widget.conversationRepository
          .sendMessage(widget.conversationId, text, base64Image);

      if (result["status"] == "success") {
        await _refreshMessages();
        _scrollToBottom();
      } else {
        ErrorHandler.showError(context,
            customMessage:
                "Impossible d'envoyer le message. Veuillez réessayer.");
      }
    } catch (e) {
      ErrorHandler.showError(context,
          customMessage:
              "Impossible d'envoyer le message. Vérifiez votre connexion internet.");
    }
  }
}
