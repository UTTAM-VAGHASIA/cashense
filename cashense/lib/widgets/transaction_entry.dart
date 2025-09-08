import 'package:animations/animations.dart';
import 'package:cashense/colors.dart';
import 'package:cashense/functions.dart';
import 'package:cashense/struct/transaction.dart';
import 'package:cashense/struct/transaction_category.dart';
import 'package:cashense/struct/transaction_tag.dart';
import 'package:cashense/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

class TransactionEntry extends StatefulWidget {
  const TransactionEntry({
    super.key,
    required this.openPage,
    required this.transaction,
  });

  final Widget openPage;
  final Transaction transaction;

  @override
  State<TransactionEntry> createState() => _TransactionEntryState();
}

class _TransactionEntryState extends State<TransactionEntry> {
  double fabSize = 50;
  TransactionCategory category = findCategory("id");

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return widget.openPage;
      },
      onClosed: () {
        print("hello");
      }(),
      tappable: false,
      closedShape: RoundedRectangleBorder(),
      closedElevation: 0.0,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            onTap: () {
              openContainer();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  CategoryIcon(category: category, size: 50),
                  Container(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.transaction.title == ""
                            ? TagIcon(
                                tag: TransactionTag(
                                  title: "test",
                                  id: "test",
                                  categoryID: "id",
                                ),
                                size: 16,
                              )
                            : TextFont(
                                text: widget.transaction.title,
                                fontSize: 20,
                              ),
                        widget.transaction.title == "" &&
                                widget.transaction.note != ""
                            ? Container(
                                height: 4,
                              )
                            : Container(),
                        widget.transaction.note == ""
                            ? Container()
                            : TextFont(
                                text: widget.transaction.note,
                                fontSize: 16,
                                maxLines: 2,
                              ),
                        widget.transaction.note == ""
                            ? Container()
                            : Container(
                                height: 4,
                              ),
                    
                        // TODO: loop through all tags relating to this entry
                        widget.transaction.title == ""
                            ? Container()
                            : TagIcon(
                                tag: TransactionTag(
                                  title: "test",
                                  id: "test",
                                  categoryID: "id",
                                ),
                                size: 12,
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8, left: 5),
                    child: TextFont(
                      text: convertToMoney(widget.transaction.amount),
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({super.key, required this.category, required this.size});

  final TransactionCategory category;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: category.color),
      child: Center(
        child: Image(
          image: AssetImage(
            "cashense/assets/icons/categories/${category.icon}",
          ),
          width: size * 0.5,
        ),
      ),
    );
  }
}

class TagIcon extends StatelessWidget {
  const TagIcon({super.key, required this.tag, required this.size});

  final TransactionTag tag;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: Theme.of(context).colorScheme.lightDarkAccentHeavy,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 5.5 * size / 14,
          right: 10 * size / 14,
          left: 10 * size / 14,
          bottom: 4 * size / 14,
        ),
        child: TextFont(
          text: "My text",
          fontSize: size,
        ),
      ),
    );
  }
}
