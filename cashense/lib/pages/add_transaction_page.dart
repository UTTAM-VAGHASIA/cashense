import 'package:cashense/colors.dart';
import 'package:cashense/functions.dart';
import 'package:cashense/widgets/button.dart';
import 'package:cashense/widgets/text_input.dart';
import 'package:cashense/widgets/text_widgets.dart';
import 'package:cashense/widgets/transaction_entry.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// TODO:
// ONLY SHOW THE TAGS THAT CORRESPOND TO SELECTED CATEGORY
// PUT RECENT USED TAGS AT THE TOP? WHEN NO CATEGORY SELECTED

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key, required this.title});

  final String title;

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: Container(),
                backgroundColor: Colors.black,
                floating: false,
                pinned: true,
                expandedHeight: 200,
                collapsedHeight: 65,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 18,
                  ),
                  title: TextFont(
                    text: "Add Transaction",
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    TextInput(labelText: "labelText"),
                  ],
                ),
              ),
              SliverFillRemaining(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Button(
              label: "Select Category",
              width: MediaQuery.of(context).size.width,
              height: 50,
              fractionScaleHeight: 0.93,
              fractionScaleWidth: 0.98,
              onTap: () {
                openSelectCategory(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> openSelectCategory(BuildContext context) {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      expand: true,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        behavior: HitTestBehavior.opaque,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: SelectCategory(),
          ),
        ),
      ),
    );
  }
}

class SelectCategory extends StatelessWidget {
  const SelectCategory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Theme.of(
              context,
            ).colorScheme.lightDarkAccent.withValues(alpha: 0.5),
          ),
        ),
        Container(
          height: 5,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            color: Theme.of(context).colorScheme.lightDarkAccent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 10.0,
            ),
            child: Column(
              children: [
                Container(
                  height: 20,
                ),
                TextFont(
                  text: "Select Category",
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                Container(
                  height: 10,
                ),
                SelectCategoryList(),
                Container(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SelectCategoryList extends StatefulWidget {
  const SelectCategoryList({super.key});

  @override
  State<SelectCategoryList> createState() => _SelectCategoryListState();
}

class _SelectCategoryListState extends State<SelectCategoryList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: listCategory()
            .asMap()
            .map(
              (index, category) => MapEntry(
                index,
                CategoryIcon(
                  category: category,
                  size: 42,
                  label: true,
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  outline: selectedIndex == index,
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}
