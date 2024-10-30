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
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
