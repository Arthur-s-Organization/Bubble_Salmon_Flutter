import 'package:bubble_salmon/widget/actionBar.dart';
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
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [ActionBar()],
      ),
    );
  }
}
