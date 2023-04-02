import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String toFormattedDate({String format = 'dd-MMM-yyyy'}) {
    final DateFormat formatter = DateFormat(format);

    return formatter.format(this);
  }

  String toFormattedTime({String format = 'HH:mm:ss'}) {
    final DateFormat formatter = DateFormat(format);

    return formatter.format(this);
  }
}
