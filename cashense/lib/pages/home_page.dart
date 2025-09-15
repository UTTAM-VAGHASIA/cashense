import 'package:cashense/struct/budget.dart';
import 'package:cashense/struct/transaction.dart';
import 'package:cashense/widgets/budget_container.dart';
import 'package:cashense/widgets/button.dart';
import 'package:cashense/widgets/fab.dart';
import 'package:cashense/widgets/fade_in.dart';
import 'package:cashense/widgets/pie_chart.dart';
import 'package:cashense/widgets/text_input.dart';
import 'package:cashense/widgets/text_widgets.dart';
import 'package:cashense/widgets/transaction_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                height: 100,
              ),
              Button(label: "button", width: 120, height: 40, onTap: () {}),
              Container(
                height: 100,
              ),
              CountUp(count: 50),
              CountUpInt(count: 50),
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  children: [
                    PieChartSample3(),
                    IgnorePointer(
                      child: Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    IgnorePointer(
                      child: Center(
                        child: Container(
                          width: 115,
                          height: 115,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 100),
              TextInput(labelText: "labelText"),
            ],
          ),
        ),
        SliverStickyHeader(
          header: TextHeader(text: "Home"),
          sliver: SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
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
              ]),
            ),
          ),
        ),

        SliverStickyHeader(
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextHeader(text: "Transactions"),
              DateDivider(date: DateTime.now()),
            ],
          ),
          sliver: SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return TransactionEntry(
                    openPage: OpenTestPage(),
                    transaction: Transaction(
                      title: "Uber",
                      date: DateTime.now(),
                      amount: 50,
                      categoryID: "id",
                      note: "this is a transaction",
                      tagIDs: ["id1"],
                    ),
                  );
                },
                childCount: 40,
              ),
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildListDelegate([
            TransactionEntry(
              openPage: OpenTestPage(),
              transaction: Transaction(
                title: "",
                date: DateTime.now(),
                amount: 50,
                categoryID: "id",
                note: "this is a transaction",
                tagIDs: ["id1", "id2"],
              ),
            ),
            TransactionEntry(
              openPage: OpenTestPage(),
              transaction: Transaction(
                title: "Uber",
                date: DateTime.now(),
                amount: 50,
                categoryID: "id",
                note: "this is a transaction",
                tagIDs: ["id1", "id2"],
              ),
            ),
          ]),
        ),
        // SliverPadding(
        //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        //     sliver: SliverGrid(
        //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        //         maxCrossAxisExtent: 650,
        //         mainAxisExtent: 95,
        //         mainAxisSpacing: 15,
        //         crossAxisSpacing: 15,
        //       ),
        //       delegate: SliverChildBuilderDelegate(
        //         (BuildContext context, int index) {
        //           return TransactionEntry(
        //             openPage: OpenTestPage(),
        //             transaction: Transaction(
        //               title: "Uber",
        //               amount: 50,
        //               categoryID: "id",
        //               date: DateTime.now(),
        //               note: "this is a transaction",
        //               tagIDs: ["id1", "id2"],
        //             ),
        //           );
        //         },
        //         childCount: 20,
        //       ),
        //     ),
        //   )
      ],
    );
  }
}
