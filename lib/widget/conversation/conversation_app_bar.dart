import 'package:bubble_salmon/class/conversation.dart';
import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/widget/conversation/group_setting_modale.dart';

import 'package:flutter/material.dart';

class ConversationAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Conversation? conversation;
  final Function()? onConversationUpdated;

  const ConversationAppBar({
    super.key,
    required this.conversation,
    this.onConversationUpdated,
  });

  @override
  State<ConversationAppBar> createState() => _ConversationAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 22);
}

class _ConversationAppBarState extends State<ConversationAppBar> {
  Future<void> _openGroupSettingsModal() async {
    if (widget.conversation == null) return;

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return GroupSettingsModal(conversation: widget.conversation!);
      },
    );

    if (result == true && widget.onConversationUpdated != null) {
      widget.onConversationUpdated!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              height: 45,
              width: 45,
              child: widget.conversation?.imageFileName != null &&
                      widget.conversation?.imageRepository != null
                  ? Image.network(
                      Global.getImagePath(widget.conversation!.imageRepository!,
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
      actions: [
        if (widget.conversation?.type == 3)
          IconButton(
            icon: Icon(Icons.more_vert,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: _openGroupSettingsModal,
          ),
      ],
      toolbarHeight: 78,
    );
  }
}
