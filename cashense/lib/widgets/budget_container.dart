import 'package:cashense/colors.dart';
import 'package:cashense/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sa3_liquid/liquid/plasma/plasma.dart';

import '../functions.dart';

class BudgetContainer extends StatelessWidget {
  final String title;
  final Color color;
  final double total;
  final double spent;

  const BudgetContainer({
    super.key,
    required this.title,
    required this.color,
    required this.total,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    var widget = Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: TextFont(
            text: title,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFont(
              text: convertToMoney(spent),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: TextFont(
                text: " leftt of ${convertToMoney(total)}",
                fontSize: 13,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        BudgetTimeline(
          startDate: "Sept 1",
          endDate: "Oct 1",
          percent: spent / total * 100,
          color: color,
        ),
        SizedBox(
          height: 14,
        ),
        Center(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: TextFont(
              text: "You can keep spending 15\$ each day.",
              fontSize: 15,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color,
            offset: Offset(0, 4),
            blurRadius: 10,
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedGooBackground(color: color),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              child: widget,
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedGooBackground extends StatelessWidget {
  final Color color;

  const AnimatedGooBackground({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.white,
        backgroundBlendMode: BlendMode.srcOver,
      ),

      child: PlasmaRenderer(
        type: PlasmaType.infinity,
        particles: 10,
        color: color,
        blur: 0.5,
        size: 1.3,
        speed: 2.9,
        offset: 0,
        blendMode: BlendMode.srcOver,
        particleType: ParticleType.atlas,
        variation1: 0,
        variation2: 0,
        variation3: 0,
        rotation: 0,
      ),
    );
  }
}

class BudgetTimeline extends StatefulWidget {
  final String startDate;
  final String endDate;
  final double percent;
  final Color color;

  const BudgetTimeline({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.percent,
    required this.color,
  });

  @override
  State<BudgetTimeline> createState() => _BudgetTimelineState();
}

class _BudgetTimelineState extends State<BudgetTimeline> {
  double todayPercent = 20;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFont(
          text: widget.startDate,
          fontSize: 12,
        ),
        Expanded(
          child: BudgetProgress(
            color: widget.color,
            percent: widget.percent,
            todayPercent: todayPercent,
          ),
        ),
        TextFont(text: widget.endDate, fontSize: 12),
      ],
    );
  }
}

class BudgetProgress extends StatelessWidget {
  final double percent;
  final Color color;
  final double todayPercent;

  const BudgetProgress({
    super.key,
    required this.percent,
    required this.color,
    required this.todayPercent,
  });

  @override
  Widget build(BuildContext context) {
    var percentText = SizedBox(
      height: 22,
      child: Padding(
        padding: EdgeInsetsGeometry.only(top: 4.3),
        child: TextFont(
          text: "${percent.toInt().toString()} %",
          fontSize: 14,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: darken(color, 0.5),
          ),
          margin: EdgeInsets.symmetric(horizontal: 8),
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          height: 20,
          child: FractionallySizedBox(
            heightFactor: 1,
            widthFactor: percent / 100,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.red,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                percent > 40 ? percentText : Container(),
              ],
            ),
          ),
        ),
        TodayIndicator(percent: todayPercent),
        percent <= 40 ? percentText : Container(),
      ],
    );
  }
}

class TodayIndicator extends StatelessWidget {
  final double percent;

  const TodayIndicator({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset(percent / 100, 0),
      child: SizedBox(
        width: 20,
        height: 39,
        child: OverflowBox(
          maxWidth: 500,
          child: SizedBox(
            width: 38,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).colorScheme.black,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 4,
                      left: 5,
                      right: 5,
                      bottom: 3,
                    ),
                    child: TextFont(
                      text: "Today",
                      textAlign: TextAlign.center,
                      fontSize: 9,
                      textColor: Theme.of(context).colorScheme.white,
                    ),
                  ),
                ),
                Container(
                  width: 3,
                  height: 21,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(5),
                    ),
                    color: Theme.of(
                      context,
                    ).colorScheme.black.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
