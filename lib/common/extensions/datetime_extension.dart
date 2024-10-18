import 'package:intl/intl.dart';
export 'datetime_extension.dart';

extension DateTimeExtensions on DateTime {
  String toDateString() {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
