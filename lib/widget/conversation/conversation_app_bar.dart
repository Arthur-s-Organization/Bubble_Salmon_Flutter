import 'package:bubble_salmon/class/conversation.dart';
import 'package:bubble_salmon/global/utils.dart';

import 'package:flutter/material.dart';

class ConversationAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Conversation? conversation;

  const ConversationAppBar({super.key, required this.conversation});

  @override
  State<ConversationAppBar> createState() => _ConversationAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 22);
}

class _ConversationAppBarState extends State<ConversationAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Transform.translate(
        offset: const Offset(
            -5, -5), // ✅ Réduction de l’espace entre la flèche et l’image
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      title: GestureDetector(
        onTap: () {
          if (ModalRoute.of(context)?.settings.name == '/conversation') {
            return;
          } else {
            Navigator.pushNamed(context, '/conversation');
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                height: 45,
                width: 45,
                child: widget.conversation?.imageFileName != null &&
                        widget.conversation?.imageRepository != null
                    ? Image.network(
                        Global.getImagePath(
                            widget.conversation!.imageRepository!,
                            widget.conversation!.imageFileName!),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/img/placeholderColor.png",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 20),
            Flexible(
              child: Text(
                widget.conversation?.name ?? "Conversation inconnue",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'FiraSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
      toolbarHeight: 78,
    );
  }
}
