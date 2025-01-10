import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    'assets/img/BubbleSalmonLogo.svg',
                    height: 60,
                    width: 60,
                  ),
                  Text(
                    "BubbleSalmon",
                    style: TextStyle(
                      fontFamily: 'FiraSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
          ),
          const SizedBox(height: 20),
          Container(
            height: 2,
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 22);
}
