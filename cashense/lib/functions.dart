import 'package:cashense/colors.dart';
import 'package:flutter/material.dart';

import 'widgets/text_widgets.dart';

void showSnackbar(
  BuildContext context,
  String text,
  Color? textColor,
  Color? backgroundColor,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: TextFont(
        text: text,
        fontSize: 16,
        textColor: textColor ?? Theme.of(context).colorScheme.white,
      ),
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.black,
    ),
  );
}

extension CapExtension on String {
  String get capitalizeFirst =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get allCaps => toUpperCase();
  String get capitalizeFirstOfEach => replaceAll(
    RegExp(' +'),
    ' ',
  ).split(' ').map((str) => str.capitalizeFirst).join(" ");
}

String getMonth(currentMonth) {
  var months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  return months[currentMonth];
}

String getMonthShort(currentMonth) {
  var months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return months[currentMonth];
}

String getWeekDay(int currentWeekDay) {
  var weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  return weekDays[currentWeekDay];
}


String getWeekDayShort(int currentWeekDay) {
  var weekDays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];
  return weekDays[currentWeekDay];
}