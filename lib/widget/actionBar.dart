import 'package:flutter/material.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.search,
                    size: 32, color: Theme.of(context).colorScheme.secondary),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline,
                    size: 32, color: Theme.of(context).colorScheme.secondary),
                onPressed: () {},
              ),
            ],
          ),
          Text(
            'Bulles',
            style: TextStyle(
              fontFamily: 'FiraSans',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.swap_vert,
                    size: 32, color: Theme.of(context).colorScheme.secondary),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.more_horiz,
                    size: 32, color: Theme.of(context).colorScheme.secondary),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
