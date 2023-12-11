import 'package:intl/intl.dart';

class FormatUtils {
  static String formatPrice(double price) {
      final formatter = NumberFormat('#,###');
      return formatter.format(price);
    }

  static String formatDate(String date) {
    DateTime inputDate = DateTime.parse(date);
    String formattedDate = '${inputDate.day.toString().padLeft(2, '0')}/${inputDate.month.toString().padLeft(2, '0')}/${inputDate.year}';
    return formattedDate;
  }
}