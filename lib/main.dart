import 'package:bubble_salmon/pages/conversation_page.dart';
import 'package:bubble_salmon/pages/home_page.dart';
import 'package:bubble_salmon/pages/login_page.dart';
import 'package:bubble_salmon/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/login',
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/conversation': (BuildContext context) => ConversationPage(),
        '/account': (BuildContext context) => HomePage(),
        '/contact': (BuildContext context) => HomePage(),
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
      },
    );
  }
}
