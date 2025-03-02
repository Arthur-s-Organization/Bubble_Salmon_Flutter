import 'package:bubble_salmon/class/conversation.dart';
import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/repositories/conversation_repository.dart';
import 'package:bubble_salmon/services/conversation_service.dart';
import 'package:bubble_salmon/widget/action_bar.dart';
import 'package:bubble_salmon/widget/bottom_bar.dart';
import 'package:bubble_salmon/widget/conversation_preview.dart';
import 'package:bubble_salmon/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<Conversation> _conversations = [];
  List<Conversation> _filteredConversations = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  final ConversationRepository _conversationRepository =
      ConversationRepository(apiConversationService: ApiConversationService());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadConversations();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadConversations();
    }
  }

  Future<void> _loadConversations([String? searchTerm]) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = searchTerm != null && searchTerm.isNotEmpty
          ? await _conversationRepository.searchConversations(searchTerm)
          : await _conversationRepository.conversationsPreview();

      setState(() {
        _isLoading = false;
        if (response["status"] == "success") {
          _conversations = response["conversations"];
          _filteredConversations = _conversations;
        } else {
          _errorMessage = response["message"];
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Erreur lors du chargement: ${e.toString()}";
      });
    }
  }

  void _toggleOrder() {
    setState(() {
      _conversations = _conversations.reversed.toList();
      _filteredConversations = _conversations;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _loadConversations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Rechercher une conversation...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: _toggleSearch,
                      ),
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      _loadConversations(value);
                    },
                  )
                : ActionBar(
                    loadConversations: _loadConversations,
                    toggleOrder: _toggleOrder,
                    toggleSearch: _toggleSearch,
                  ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredConversations.isEmpty
                    ? Center(
                        child: Text(
                          _isSearching
                              ? "Aucune conversation trouvée pour votre recherche."
                              : "Aucune conversation pour le moment.",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(top: 12),
                        itemCount: _filteredConversations.length,
                        itemBuilder: (context, index) {
                          final conversation = _filteredConversations[index];
                          return InkWell(
                            child: ConversationPreview(
                              name: conversation.name,
                              message: conversation.lastMessage?.text ??
                                  "Aucun message",
                              time: Global.formatPreviewTime(
                                conversation.updatedAt,
                              ),
                              imageFileName: conversation.imageFileName,
                              imageRepository: conversation.imageRepository,
                            ),
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                '/conversation',
                                arguments: {
                                  'conversationId': conversation.id,
                                },
                              );

                              if (result == true) {
                                _loadConversations();
                              }
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(currentIndex: 1, context: context),
    );
  }
}
