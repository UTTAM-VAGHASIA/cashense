import 'package:cashense/struct/budget.dart';
import 'package:cashense/widgets/budget_container.dart';
import 'package:cashense/widgets/fab.dart';
import 'package:cashense/widgets/text_widgets.dart';
import 'package:cashense/widgets/transaction_entry.dart';
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFont(text: "test"),
            BudgetContainer(
              budget: Budget(
                title: "Budget Name",
                startDate: DateTime.now(),
                endDate: DateTime.now(),
                period: "month",
                periodLength: 10,
                color: Color(0x4F6ECA4A),
                total: 500,
                spent: 210,
              ),
            ),
            TransactionEntry(openPage: OpenTestPage()),
          ],
        ),
      ),
    );
  }
}
