import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class TransactionEntry extends StatefulWidget {
  const TransactionEntry({super.key, required this.openPage});

  final Widget openPage;

  @override
  State<TransactionEntry> createState() => _TransactionEntryState();
}

class _TransactionEntryState extends State<TransactionEntry> {
  double fabSize = 50;

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
        return ListTile(
          leading: FlutterLogo(),
          onTap: openContainer,
          title: Text('Test'),
          subtitle: Text('Test'),
        );
      },
    );
  }
}
