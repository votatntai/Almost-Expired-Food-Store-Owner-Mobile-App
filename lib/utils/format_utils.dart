import 'package:intl/intl.dart';

class FormatUtils {
  static String formatPrice(double price) {
      final formatter = NumberFormat('#,###');
      return formatter.format(price);
    }

    // static String formatDate()
}