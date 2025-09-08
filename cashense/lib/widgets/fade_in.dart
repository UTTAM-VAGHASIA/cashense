import 'package:flutter/material.dart';

class FadeIn extends StatefulWidget {
  const FadeIn({super.key, required this.child});

  final Widget child;

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> {
  double widegtOpacity = 0;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 10), () {
      setState(() {
        widegtOpacity = 1;
      });
      print("Changed");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widegtOpacity,
      duration: Duration(seconds: 1),
      child: widget.child,
    );
  }
}
