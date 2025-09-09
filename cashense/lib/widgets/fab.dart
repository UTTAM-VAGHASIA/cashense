import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class FAB extends StatelessWidget {
  final Widget openPage;

  const FAB({super.key, required this.openPage});

  final double fabSize = 60;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return openPage;
      },
      closedElevation: 6.0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(fabSize / 2),
      ),
      closedColor: Theme.of(context).colorScheme.secondary,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return InkWell(
          onTap: () {
            openContainer();
          },
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
      body: GestureDetector(
        onDoubleTap: () {
          print("hello");
        },
        onPanUpdate: (details) {
          if (details.delta.dy > 10 || details.delta.dx > 10) {
            print("Hello");
            Navigator.of(context).pop();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.red[100],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
