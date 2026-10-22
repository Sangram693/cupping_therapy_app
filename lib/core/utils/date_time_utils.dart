import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._();

  static String formatShortDate(DateTime dateTime, {String locale = 'en'}) =>
      DateFormat.yMMMd(locale).format(dateTime);

  static String getDayName(DateTime dateTime, {String locale = 'en'}) =>
      DateFormat.E(locale).format(dateTime);
}
