import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class FAB extends StatefulWidget {
  final Widget openPage;

  const FAB({super.key, required this.openPage});

  @override
  State<FAB> createState() => _FABState();
}

class _FABState extends State<FAB> {
  double fabSize = 50;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return widget.openPage;
      },
      closedElevation: 6.0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(fabSize / 2),
      ),
      closedColor: Theme.of(context).colorScheme.secondary,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return InkWell(
          onTap: () => openContainer,
          child: SizedBox(
            height: fabSize,
            width: fabSize,
            child: Center(
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        );
      },
    );
  }
}


class OpenTestPage extends StatelessWidget {
  const OpenTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Page"),
      ),
      body: Container(),
    );
  }
}