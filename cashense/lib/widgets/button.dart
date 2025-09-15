import 'package:cashense/colors.dart';
import 'package:cashense/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  const Button({
    super.key,
    required this.label,
    required this.width,
    required this.height,
    this.fontSize = 16,
    this.fractionScaleHeight = 0.93,
    this.fractionScaleWidth = 0.93,
    required this.onTap,
    this.color,
  });

  final String label;
  final double width;
  final double height;
  final double fontSize;
  final double fractionScaleHeight;
  final double fractionScaleWidth;
  final VoidCallback onTap;
  final Color? color;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool isTapped = false;

  void _shrink() {
    setState(() {
      isTapped = true;
    });
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        isTapped = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color:
              widget.color ??
              Theme.of(
                context,
              ).colorScheme.accentColor.withValues(alpha: 0.8),
          child: InkWell(
            onHighlightChanged: (value) {
              setState(() {
                isTapped = value;
              });
            },
            onTap: () {
              _shrink();
              widget.onTap();
            },
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              height: isTapped
                  ? widget.height * (widget.fractionScaleHeight)
                  : widget.height,
              width: isTapped
                  ? widget.width * (widget.fractionScaleWidth)
                  : widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color:
                        widget.color ??
                        Theme.of(
                          context,
                        ).colorScheme.accentColor.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: TextFont(
                  text: widget.label,
                  fontSize: widget.fontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
