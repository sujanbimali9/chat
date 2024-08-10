import 'package:intl/intl.dart' as intl;

class DateFormatter {
  static String formatDateSeparator(DateTime date) {
    final DateTime today = DateTime.now();

    if (date.year != today.year) {
      return intl.DateFormat('dd MMM yyyy, HH:mm').format(date);
    } else if (date.month != today.month ||
        _getWeekOfYear(date) != _getWeekOfYear(today)) {
      return intl.DateFormat('dd MMM HH:mm').format(date);
    } else if (date.day != today.day) {
      return intl.DateFormat('E HH:mm').format(date);
    }
    return intl.DateFormat('HH:mm').format(date);
  }

  static int _getWeekOfYear(DateTime date) {
    final int dayOfYear = int.parse(intl.DateFormat('D').format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  static String format(String date) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(date));
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);
    if (difference.inDays > 1 && difference.inDays < 365) {
      return '${dateTime.day} ${_extractMonth(date)}';
    } else if (difference.inDays >= 365) {
      return '${dateTime.day} ${_extractMonth(date)} ${dateTime.year}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes < 1) {
      return 'Just now';
    }
    return '${dateTime.day} ${_extractMonth(date)} ${dateTime.year}';
  }

  static String _extractMonth(String date) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(date));
    return _month[dateTime.month - 1][dateTime.month.toString()];
  }

  static const List<Map<String, dynamic>> _month = [
    {'1': 'Jan', 'days': 31},
    {'2': 'Feb', 'days': 28},
    {'3': 'March', 'days': 31},
    {'4': 'April', 'days': 30},
    {'5': 'May', 'days': 31},
    {'6': 'June', 'days': 30},
    {'7': 'July', 'days': 31},
    {'8': 'Aug', 'days': 31},
    {'9': 'Sept', 'days': 30},
    {'10': 'Oct', 'days': 31},
    {'11': 'Nov', 'days': 30},
    {'12': 'Dec', 'days': 31},
  ];
}
