import 'package:cashense/widgets/budget_container.dart';
import 'package:cashense/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFont(text: "test"),
        BudgetContainer(
          title: "Budget Name",
          color: Color(0x4FECA4A),
          total: 500,
          spent: 49.1,
        ),
      ],
    );
  }
}
