import 'package:intl/intl.dart';
export 'datetime_extension.dart';

extension DateTimeExtensions on DateTime {
  String toDateString() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String toDateTimeString() {
    return DateFormat('EEE d MMMM yyyy \'at\' HH:mm').format(this);
  }

  String toTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    String agoText(int value, String unit) {
      return '$value $unit${value == 1 ? "" : "s"} ago';
    }

    if (difference.inDays > 0) {
      return agoText(difference.inDays, 'day');
    } else if (difference.inHours > 0) {
      return agoText(difference.inHours, 'hour');
    } else if (difference.inMinutes > 0) {
      return agoText(difference.inMinutes, 'minute');
    } else {
      return 'Just now';
    }
  }
}
