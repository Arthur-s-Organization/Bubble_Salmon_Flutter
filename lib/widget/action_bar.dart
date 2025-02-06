import 'package:bubble_salmon/repositories/contact_repository.dart';
import 'package:bubble_salmon/repositories/conversation_repository.dart';
import 'package:bubble_salmon/services/contact_service.dart';
import 'package:bubble_salmon/services/conversation_service.dart';
import 'package:bubble_salmon/widget/create_group_dialog.dart';
import 'package:flutter/material.dart';

class ActionBar extends StatelessWidget {
  final Future<void> Function() loadConversations;
  const ActionBar({super.key, required this.loadConversations});

  void _showConversationTypeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Créer une conversation :',
                  style: TextStyle(
                    fontFamily: 'FiraSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Individuel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/contact');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.group,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'En groupe',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context); // Ferme le bottom sheet
                  final result = await showDialog(
                    context: context,
                    builder: (context) => CreateGroupDialog(
                      contactRepository: ContactRepository(
                        apiContactService: ApiContactService(),
                      ),
                      conversationRepository: ConversationRepository(
                        apiConversationService: ApiConversationService(),
                      ),
                    ),
                  );
                  if (result == true) {
                    await loadConversations();
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.search,
                size: 28, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add_circle,
                size: 32, color: Theme.of(context).colorScheme.secondary),
            onPressed: () => _showConversationTypeDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.swap_vert,
                size: 28, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
