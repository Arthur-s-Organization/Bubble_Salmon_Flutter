import 'package:bubble_salmon/pages/conversation_page.dart';
import 'package:bubble_salmon/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Utilisation du thème
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/conversation': (BuildContext context) => ConversationPage(),
        '/account': (BuildContext context) => HomePage(),
        '/contact': (BuildContext context) => HomePage(),
        '/login': (BuildContext context) => HomePage(),
        '/register': (BuildContext context) => HomePage(),
      },
    );
  }
}
