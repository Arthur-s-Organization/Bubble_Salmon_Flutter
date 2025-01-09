import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/widget/actionBar.dart';
import 'package:bubble_salmon/widget/bottomBar.dart';
import 'package:bubble_salmon/widget/conversation_preview.dart';
import 'package:bubble_salmon/widget/custom_appBar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 12),
        itemCount: 11, // conversation.length +1 (Pour l'actionBar)
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ActionBar(),
            );
          }
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
      bottomNavigationBar:
          BottomBar(currentIndex: _currentIndex, onTabSelected: _onTabSelected),
    );
  }
}
