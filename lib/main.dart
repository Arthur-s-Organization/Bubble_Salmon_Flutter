import 'package:bubble_salmon/global/dependency_injection.dart';
import 'package:bubble_salmon/pages/account_page.dart';
import 'package:bubble_salmon/pages/contact_page.dart';
import 'package:bubble_salmon/pages/conversation_page.dart';
import 'package:bubble_salmon/pages/home_page.dart';
import 'package:bubble_salmon/pages/login_page.dart';
import 'package:bubble_salmon/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme/app_theme.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/login',
      supportedLocales: const [Locale('fr', 'FR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: <String, WidgetBuilder>{
        '/home': (context) => HomePage(),
        '/conversation': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return ConversationPage(
            conversationId: args['conversationId'],
            conversationRepository: DependencyInjection.conversationRepository,
            authRepository: DependencyInjection.authRepository,
          );
        },
        '/account': (context) => AccountPage(),
        '/contact': (context) => ContactPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
