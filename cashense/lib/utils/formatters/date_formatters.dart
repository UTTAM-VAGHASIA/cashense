import 'package:intl/intl.dart';

/// Collection of date formatting utilities
class DateFormatters {
  DateFormatters._();

  // Common date formats
  static final DateFormat _dayMonthYear = DateFormat('dd/MM/yyyy');
  static final DateFormat _monthDayYear = DateFormat('MM/dd/yyyy');
  static final DateFormat _yearMonthDay = DateFormat('yyyy-MM-dd');
  static final DateFormat _dayMonthYearWithTime = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _monthDayYearWithTime = DateFormat('MM/dd/yyyy hh:mm a');
  static final DateFormat _time12Hour = DateFormat('hh:mm a');
  static final DateFormat _time24Hour = DateFormat('HH:mm');
  static final DateFormat _dayName = DateFormat('EEEE');
  static final DateFormat _monthName = DateFormat('MMMM');
  static final DateFormat _shortDayName = DateFormat('EEE');
  static final DateFormat _shortMonthName = DateFormat('MMM');
  static final DateFormat _dayMonthShort = DateFormat('dd MMM');
  static final DateFormat _dayMonthYearShort = DateFormat('dd MMM yyyy');
  static final DateFormat _monthYear = DateFormat('MMM yyyy');
  static final DateFormat _fullDateTime = DateFormat('EEEE, dd MMMM yyyy HH:mm');
  static final DateFormat _iso8601 = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

  /// Format date as dd/MM/yyyy
  static String toDayMonthYear(DateTime date) {
    return _dayMonthYear.format(date);
  }

  /// Format date as MM/dd/yyyy
  static String toMonthDayYear(DateTime date) {
    return _monthDayYear.format(date);
  }

  /// Format date as yyyy-MM-dd
  static String toYearMonthDay(DateTime date) {
    return _yearMonthDay.format(date);
  }

  /// Format date as dd/MM/yyyy HH:mm
  static String toDayMonthYearWithTime(DateTime date) {
    return _dayMonthYearWithTime.format(date);
  }

  /// Format date as MM/dd/yyyy hh:mm a
  static String toMonthDayYearWithTime(DateTime date) {
    return _monthDayYearWithTime.format(date);
  }

  /// Format time as hh:mm a (12-hour format)
  static String toTime12Hour(DateTime date) {
    return _time12Hour.format(date);
  }

  /// Format time as HH:mm (24-hour format)
  static String toTime24Hour(DateTime date) {
    return _time24Hour.format(date);
  }

  /// Get day name (e.g., Monday)
  static String getDayName(DateTime date) {
    return _dayName.format(date);
  }

  /// Get month name (e.g., January)
  static String getMonthName(DateTime date) {
    return _monthName.format(date);
  }

  /// Get short day name (e.g., Mon)
  static String getShortDayName(DateTime date) {
    return _shortDayName.format(date);
  }

  /// Get short month name (e.g., Jan)
  static String getShortMonthName(DateTime date) {
    return _shortMonthName.format(date);
  }

  /// Format as dd MMM (e.g., 15 Jan)
  static String toDayMonthShort(DateTime date) {
    return _dayMonthShort.format(date);
  }

  /// Format as dd MMM yyyy (e.g., 15 Jan 2024)
  static String toDayMonthYearShort(DateTime date) {
    return _dayMonthYearShort.format(date);
  }

  /// Format as MMM yyyy (e.g., Jan 2024)
  static String toMonthYear(DateTime date) {
    return _monthYear.format(date);
  }

  /// Format as full date time (e.g., Monday, 15 January 2024 14:30)
  static String toFullDateTime(DateTime date) {
    return _fullDateTime.format(date);
  }

  /// Format as ISO 8601 string
  static String toIso8601(DateTime date) {
    return _iso8601.format(date.toUtc());
  }

  /// Parse ISO 8601 string to DateTime
  static DateTime? fromIso8601(String dateString) {
    try {
      return _iso8601.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get relative time (e.g., "2 hours ago", "Yesterday", "Last week")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        } else if (difference.inMinutes == 1) {
          return '1 minute ago';
        } else {
          return '${difference.inMinutes} minutes ago';
        }
      } else if (difference.inHours == 1) {
        return '1 hour ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 14) {
      return 'Last week';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays < 60) {
      return 'Last month';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    }
  }

  /// Get time until date (e.g., "in 2 hours", "Tomorrow", "Next week")
  static String getTimeUntil(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      return getRelativeTime(date);
    }

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Now';
        } else if (difference.inMinutes == 1) {
          return 'In 1 minute';
        } else {
          return 'In ${difference.inMinutes} minutes';
        }
      } else if (difference.inHours == 1) {
        return 'In 1 hour';
      } else {
        return 'In ${difference.inHours} hours';
      }
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return 'In ${difference.inDays} days';
    } else if (difference.inDays < 14) {
      return 'Next week';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? 'In 1 week' : 'In $weeks weeks';
    } else if (difference.inDays < 60) {
      return 'Next month';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? 'In 1 month' : 'In $months months';
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? 'In 1 year' : 'In $years years';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }

  /// Check if date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
           date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if date is this month
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Check if date is this year
  static bool isThisYear(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year;
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Get end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    final daysUntilSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysUntilSunday)));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  /// Get start of year
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Get end of year
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59, 999);
  }
}