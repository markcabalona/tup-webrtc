import 'package:intl/intl.dart';

extension DoubleFormatter on double {
  String toMoney() {
    final formatter = NumberFormat("#,##0.00", "en_US");

    return formatter.format(this);
  }
}
