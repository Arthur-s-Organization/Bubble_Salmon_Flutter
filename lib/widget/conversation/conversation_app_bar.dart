import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConversationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ConversationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: Transform.translate(
              offset: const Offset(0, -10), // Décalage du bouton vers le haut
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
            title: Transform.translate(
              offset: const Offset(
                  0, -10), // Décalage du texte et de l'image vers le haut
              child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 30.0), // Ajout du padding à droite
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/img/BubbleSalmonLogo.svg',
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            "Conversation bdfhzbrirbgrbghirbgkherbgzehbghrebgkehzbgrehbgkj", // Exemple
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'FiraSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  if (ModalRoute.of(context)?.settings.name ==
                      '/conversation') {
                    return;
                  } else {
                    Navigator.pushNamed(context, '/conversation');
                  }
                },
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 78,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 22);
}
