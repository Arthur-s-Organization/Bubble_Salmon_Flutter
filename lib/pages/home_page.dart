import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/widget/actionBar.dart';
import 'package:bubble_salmon/widget/conversation_preview.dart';
import 'package:bubble_salmon/widget/custom_appBar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          const ActionBar(),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(top: 12),
              itemCount: 10, // conversation.length
              itemBuilder: (context, index) {
                return ConversationPreview(
                  name: "Arthur Reynet", //conversation.name
                  message: //conversation.lastMessage.text || "placeholder pour une image"
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas ",
                  time: Global.formatTime(DateTime
                      .now()), //Global.formatTime(Conversation.lastMessage.createdAt)
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
            ),
          ),
        ],
      ),
    );
  }
}
